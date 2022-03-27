FROM python:3.7
ENV DockerHome=/home/src/app
WORKDIR $DockerHome
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN pip install --upgrade pip
COPY . $DockerHome
RUN pip install -r requirements.txt
EXPOSE 8000
#CMD python manage.py migrate
#EXPOSE 8000
#CMD python manage.py migrate
ENTRYPOINT ["/home/src/app/cartloop.sh"]
CMD python manage.py runserver 0.0.0.0:8000