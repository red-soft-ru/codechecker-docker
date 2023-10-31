FROM ubuntu:20.04

ENV CC_LOGGER_GCC_LIKE "gcc:g++:clang:cc1:cc1plus"
ENV DEBIAN_FRONTEND noninteractive

RUN sed /etc/apt/sources.list -e 's|http://.*ubuntu/|http://mirror.yandex.ru/ubuntu/|' -i
RUN apt update 
RUN apt install -y wget gnupg2 curl lsb-core g++ make autogen autoconf libtool libz-dev libldap2-dev libkrb5-dev python3-pip unzip cmake cppcheck python3-virtualenv

RUN wget https://apt.llvm.org/llvm-snapshot.gpg.key
RUN apt-key add llvm-snapshot.gpg.key
RUN echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal main' > /etc/apt/sources.list.d/clang.list
RUN apt update
RUN apt install -y clang-tidy-18

RUN virtualenv /codechecker
RUN /codechecker/bin/python3 -m pip install codechecker==6.22.2.post1

RUN cd /usr/bin && \
    rm -f clang clang-tidy  && \
    ln -s clang-18 clang && \
    ln -s clang-tidy-18 clang-tidy && \
    ln -s /codechecker/bin/CodeChecker .



#./autogen.sh --enable-binreloc --with-builtin-tommath --with-builtin-tomcrypt --with-builtin-icu
#./venv/bin/CodeChecker log  --build "make -j4" --output ./compile_commands.json
#./venv/bin/CodeChecker analyze -j4 --ctu --enable sensitive --analyzers clangsa clang-tidy cppcheck --output ./reports ./compile_commands.json
#./venv/bin/CodeChecker parse ./reports --export html --output ./reports_html

#./venv/bin/CodeChecker store --trim-path-prefix $(pwd) --name ${RDB_VERSION} ./reports --url http://10.81.81.123:8001/rdb50

