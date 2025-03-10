FROM alpine:3.21
RUN apk add --no-cache \
    bash \
    bind-tools \
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

CMD ["/bin/sh"] 
