FROM python:3.7
ENV DockerHome=/home/src/app
WORKDIR $DockerHome
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV SECRET_KEY=$SECRET_KEY
RUN pip install --upgrade pip
COPY . $DockerHome
RUN pip install -r requirements.txt
EXPOSE 8000
# Run Migrations as this not not execute in on docker
RUN chmod +x /home/src/app/cartloop.sh
ENTRYPOINT ["/home/src/app/cartloop.sh"]

CMD python manage.py runserver 0.0.0.0:8000