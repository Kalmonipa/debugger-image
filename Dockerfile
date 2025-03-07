FROM alpine:3.14
RUN apk add --no-cache \
    bash \
    bind-tools \
    busybox-extras \
    curl \
    iproute2 \
    iputils \
    jq \
    net-tools \
    nmap \
    socat \
    tcpdump \
    vim \
    wget 

CMD ["/bin/bash"] 
