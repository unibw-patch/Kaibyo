Build container
docker build --tag zombmc .

Run the container
docker run --name zombmc -w /home/Dat3M/zombmc/scripts/ -it zombmc

Start the container
docker start -i zombmc
