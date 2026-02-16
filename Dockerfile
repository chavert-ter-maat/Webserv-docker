FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y \
    g++-12 make curl siege libcurl4-openssl-dev clang git build-essential wget libc6-dbg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV VALGRIND_VERSION=3.23.0
RUN wget https://sourceware.org/pub/valgrind/valgrind-${VALGRIND_VERSION}.tar.bz2 && \
    tar xjf valgrind-${VALGRIND_VERSION}.tar.bz2 && \
    cd valgrind-${VALGRIND_VERSION} && \
    ./configure && \
    make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf valgrind-${VALGRIND_VERSION} valgrind-${VALGRIND_VERSION}.tar.bz2

WORKDIR /usr/src/app

# Clone repo INTO /usr/src/app
RUN git clone https://github.com/chavert-ter-maat/Webserv.git ./

# Build
RUN make && chmod +x ./webserv

COPY ./basic_config.txt /usr/src/app/basic_config.txt
RUN chmod 644 /usr/src/app/basic_config.txt

RUN mkdir -p /usr/src/app/html/uploads

EXPOSE 8080-8093
ENTRYPOINT ["./webserv"]
CMD ["/usr/src/app/basic_config.txt"]