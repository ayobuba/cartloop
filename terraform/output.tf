output "ec2-public-dns" {
  value = aws_spot_instance_request.cartloop_spot_instance.public_dns
}