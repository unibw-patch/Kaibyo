# Download base image ubuntu 18.04
FROM ubuntu:18.04

# Update Ubuntu Software repository
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y lsb-release && \
    apt-get install -y sudo && \
    apt-get install -y wget && \
    apt-get install -y gnupg && \
    apt-get install -y maven && \
    apt-get install -y curl && \
    apt-get install -y build-essential && \
    apt-get install -y libcap-dev && \
    apt-get install -y cmake && \
    apt-get install -y libncurses5-dev && \
    apt-get install -y python3-minimal && \
    apt-get install -y python3-pip && \
    apt-get install -y unzip && \
    apt-get install -y libtcmalloc-minimal4 && \
    apt-get install -y libgoogle-perftools-dev && \
    apt-get install -y libsqlite3-dev && \
    apt-get install -y doxygen && \
    apt-get install -y clang-6.0 && \
    apt-get install -y llvm-6.0 && \
    apt-get install -y llvm-6.0-dev && \
    apt-get install -y llvm-6.0-tools && \
    apt-get install -y minisat && \
    apt-get install -y bison && \
    apt-get install -y flex && \
    apt-get install -y libboost-all-dev && \
    apt-get install -y python && \
    apt-get install -y perl && \
    apt-get install -y nano && \
    apt-get install -y software-properties-common

RUN pip3 install tabulate

# Install SMACK
RUN cd home && \
    git clone https://github.com/smackers/smack.git && \
    cd smack && \
    sed -i 's/TEST_SMACK=1/TEST_SMACK=0/' bin/build.sh && \
    bash bin/build.sh

# Install Dat3M
RUN cd home && \
    git clone https://github.com/unibw-patch/Dat3M.git && \
    cd Dat3M && \
    mvn install:install-file -Dfile=lib/z3-4.8.6.jar -DgroupId=com.microsoft -DartifactId="z3" -Dversion=4.8.6 -Dpackaging=jar && \
    mvn clean install -DskipTests

# Install spectector
RUN cd home && \
    git clone https://github.com/ciao-lang/ciao && \
    cd ciao && \
    ./ciao-boot.sh local-install && \
    build/bin/ciao get github.com/spectector/spectector && \
    ln -s ~/.ciao/build/bin/spectector /usr/local/bin/spectector

# Install STP
RUN cd home && \
    git clone https://github.com/stp/stp && \
    cd stp && \
    git submodule init && git submodule update && \
    mkdir build && \
    cd build && \
    cmake .. && \
    cmake --build . && \
    sudo cmake --install .

# Install uClibc
RUN cd home && \
    git clone https://github.com/klee/klee-uclibc.git && \
    cd klee-uclibc && \
    ./configure --make-llvm-lib && \
    make -j2

# Install KLEE
RUN cd home && \
    git clone https://github.com/winter2020/kleespectre.git && \
    cd kleespectre/klee/ && \
    mkdir build && \
    cd build && \
    cp ../build.sh . && \
    sed -i 's/-DKLEE_UCLIBC_PATH=\/PATH\/TO\/UCLIBC\//-DKLEE_UCLIBC_PATH=\/home\/klee-uclibc\//' ./build.sh && \
    sed -i 's/\/PATH\/TO\/SOURCE\//\/home\/kleespectre\/klee\/ \\/' ./build.sh && \
    echo -n \ \ -DENABLE_UNIT_TESTS=OFF -DENABLE_SYSTEM_TESTS=OFF >> build.sh && \
    ./build.sh && \
    make -j 10

ENV DAT3M_HOME=/home/Dat3M
ENV PATH=$DAT3M_HOME/:$PATH
ENV LD_LIBRARY_PATH=$DAT3M_HOME/lib/:$LD_LIBRARY_PATH
ENV KLEE_HOME=/home/kleespectre/klee