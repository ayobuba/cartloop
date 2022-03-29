resource "aws_spot_instance_request" "cartloop_spot_instance" {
  ami           = data.aws_ami.ubuntu.id
  spot_price    = "0.03"
  spot_type = "one-time"
  instance_type = "t3.medium"
  associate_public_ip_address = true
  key_name = "cartloop"
  root_block_device {
    volume_size = 20
  }
  vpc_security_group_ids = [aws_security_group.k8_group.id]
  wait_for_fulfillment = true
#  user_data = local.instance-userdata

  tags = {
    Name = "Cartloop"
  }
}


resource "aws_security_group" "k8_group" {
  name        = "Access-SG"
  description = "Allow ports and 22"


  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    //cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    description = "Allow 22 from our public IP"
  }

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  ingress {
    from_port   = 8000
    protocol    = "TCP"
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP"
  }

  ingress {
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "null_resource" "config_minikube" {

  triggers = {
    build_number = timestamp()
  }
  depends_on = [aws_spot_instance_request.cartloop_spot_instance]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_spot_instance_request.cartloop_spot_instance.public_dns
      private_key = file("cartloop.pem")
      agent       = false
      timeout     = "2m"
    }

    inline = [
      "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin/kubectl",
      "sudo apt-get update -y &&  sudo apt-get install -y docker.io",
      "curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && chmod +x minikube && sudo mv minikube /usr/local/bin/",
      "sudo apt install conntrack",
      "sudo sysctl fs.protected_regular=0", #Used because no vm was set up on the instance
      "sudo minikube start --driver=none",
      "sudo minikube addons enable ingress",
      "sudo minikube status"
    ]
  }
}


resource "null_resource" "config_deploy" {

  triggers = {
    build_number = timestamp()
  }
  depends_on = [null_resource.config_minikube]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_spot_instance_request.cartloop_spot_instance.public_dns
      private_key = file("cartloop.pem")
      agent       = false
      timeout     = "2m"
    }

    inline = [
          "sudo apt install git -y",
          "git config --global user.name ${var.git_user_name}",
          "git config --global user.email ${var.git_user_email}",
          "ssh-keyscan -H github.com >> ~/.ssh/known_hosts",
          "rm -rf cartloop",
          "git clone https://github.com/ayobuba/cartloop.git",
          "cd cartloop/k8s/",
          "sudo kubectl apply -f ./redis-deployment.yml",
          "sudo kubectl apply -f ./django-deployment.yml",
          "sudo kubectl patch svc cartloop -p '{${var.spec}: {${var.type}: ${var.LoadBalancer}, ${var.externalIPs}:[${var.eip}]}}'",
          "echo Deployment is in progress status",
          "sleep 40",
          "sudo kubectl get deployments",
          "sudo kubectl get service",
          "sudo minikube service cartloop --url",

    ]


  }
}

#172.31.32.77