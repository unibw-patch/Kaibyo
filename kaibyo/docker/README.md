Build container
docker build --tag kaibyo .

Run the container
docker run --name kaibyo -w /home/Kaibyo -it kaibyo

Start the container
docker start -i kaibyo
