Build container
docker build --tag kaibyo .

Run the container
docker run --name kaibyo -w /home/Dat3M/kaibyo/scripts/ -it kaibyo

Start the container
docker start -i kaibyo
