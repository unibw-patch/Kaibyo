# Download base image ubuntu 18.04
FROM ubuntu:18.04

# Update Ubuntu Software repository
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y sudo && \
    apt-get install -y maven && \
    apt-get install -y build-essential && \
    apt-get install -y cmake && \
    apt-get install -y nano && \
    apt-get install -y z3 && \
    apt-get install -y cvc4 && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:sri-csl/formal-methods && \
    apt-get update && \
    apt-get install -y yices2

# Install Kaibyo
RUN cd home && \
    git clone https://github.com/unibw-patch/Kaibyo.git && \
    cd Kaibyo && \
    mvn install:install-file -Dfile=lib/z3-4.8.6.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.8.6 -Dpackaging=jar && \
    mvn clean install -DskipTests

ENV DAT3M_HOME=/home/Kaibyo
ENV PATH=$DAT3M_HOME/:$PATH
ENV LD_LIBRARY_PATH=$DAT3M_HOME/lib/:$LD_LIBRARY_PATH