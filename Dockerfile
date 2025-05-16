FROM alpine:3.21
RUN apk add --no-cache \
    aws-cli \
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
