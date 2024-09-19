FROM ubuntu:18.04
LABEL maintainer=damaris.delcarpio@unmsm.edu.pe

# home directory
ENV HOME /home/pwnies

ENV PINTOS_ROOT=/home/pwnies/pintos
RUN mkdir -p ${HOME}

# install prerequisite packages
RUN apt-get update && apt-get -y install build-essential automake git libncurses5-dev expat libexpat1-dev wget

WORKDIR ${HOME}

# we are not sure if we need to copy it all
COPY . ${PINTOS_ROOT} 

# build toolchain
ENV SWD=/home/pwnies/toolchain
RUN mkdir -p $SWD
RUN cd ${PINTOS_ROOT} && src/misc/toolchain-build.sh $SWD

# install qemu
RUN apt-get update && apt-get install -y qemu

# build Bochs from source
RUN apt-get install -y libx11-dev libxrandr-dev
RUN cd ${PINTOS_ROOT} && src/misc/bochs-2.6.2-build.sh $SWD/x86_64

# build pintos utility tools
ENV dest=$SWD/x86_64
RUN cd $PINTOS_ROOT/src/utils &&\
    make &&\
    cp backtrace pintos Pintos.pm pintos-gdb pintos-set-cmdline pintos-mkdisk setitimer-helper squish-pty squish-unix $dest/bin &&\
    mkdir $dest/misc &&\
    cp ../misc/gdb-macros $dest/misc

# install cgdb
RUN apt-get install -y cgdb

# add toolchain into path
RUN echo PATH=/home/pwnies/toolchain/x86_64/bin:$PATH >> ~/.bashrc
RUN echo PATH=/home/pwnies/pintos/src/utils:$PATH >> ~/.bashrc

# remove the pintos dir
RUN rm -rf /home/pwnies/pintos

# docker will end executing immediatedly without this
CMD ["sleep", "infinity"]
