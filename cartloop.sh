#!/bin/bash
echo "Migrate the Database at startup of project"

# Wait for few minute and run db migraiton
while ! python manage.py migrate  2>&1; do
   echo "Migration is in progress"
   sleep 3
done

echo "Django docker configured successfully."

exec "$@"

#python manage.py migrate
#docker image build .  --tag cartloop
#sleep 3
#docker tag cartloop:latest  ayobuba/cartloop:latest
#sleep 3
#docker push ayobuba/cartloop:latest