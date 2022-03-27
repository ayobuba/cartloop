# Cartloop DevOps Assingment (Hello World Django App)

The project contains a hello world API, the implementation can be found under `helloworld/views.py`. The API returns a simple JSON response with the hello world text. The project should solely be used for the purpose of assignment and should not be shared with anyone.

## Prerequisites

- [Python 3.5 or above](https://www.python.org/downloads/)
- [Redis](https://redis.io/download)
- [Virtualenv](https://virtualenv.pypa.io/en/latest/installation.html)

## Installation

- Create a Virtualenv
    ```
    virtualenv myvenv -p python3
    ```

- Activate the Virtual env
    
    ```
    source myvenv/bin/activate
    ```

- Get inside the project directory and install all the dependencies

    ```
    pip install -r requirements.txt
    ```
- Apply Migrations (This would create all required tables in the sqllite DB)
    ```
    python manage.py migrate
    ```
- Run the Django Server
    ```
    python manage.py runserver
    ```

After successful completion of the above steps, the api would be accessible at `http://localhost:8000/api/hello_world`. 

<B>NOTE</B>: You will have to update the Redis url inside `cartloop/settings.py` under `CACHES` if required.


## Tasks to be completed:

1. Dockerize the application
2. Write kubernetes manifests for creating deployment for the hello world API (2 Pods).
3. Write kubernetes manifests for creating deployment for the Redis (1 Pod).
4. Create a kubernetes service for storing secrets.
5. Make the hello world API publicly accessible.

## key Points

1. The Hello world API pod should only start after the Redis pod has started running successfully. Configure `Liveness` and `Readiness` probes for the helloworld pod.
2. The Redis pod shouldn't be accessible to the world.
3. Secrets (ex: `SECRET_KEY` in the `cartloop/settings.py`) should be retrieved from the kubernetes secrets service.

