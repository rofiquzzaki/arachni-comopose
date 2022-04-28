FROM amd64/ubuntu:20.04

MAINTAINER Jerry Cai

ARG ARACHNI_VERSION=arachni-1.6.1-0.6.1
ENV SERVER_ROOT_PASSWORD arachni
ENV ARACHNI_USERNAME arachni
ENV ARACHNI_PASSWORD password
ENV DB_ADAPTER sqlite

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get -y install \
    openssh-server \
    wget \
    curl \
    supervisor \
    unzip \
    libatk1.0-0 \
    libatk1.0-data \
    libatk1.0-dev \
    libatk-bridge2.0-dev \
    libcups2-dev \
    libcups2 \
    libxcomposite-dev \
    libxdamage-dev \
    libxdamage1 \
    libxrandr-dev \
    libgbm-dev \
    libxkbcommon-dev \
    libpango1.0-dev \ 
    libnss3 \
    libasound2

RUN mkdir /var/run/sshd && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

#COPY "$PWD"/${ARACHNI_VERSION}-linux-x86_64.tar.gz ${ARACHNI_VERSION}-linux-x86_64.tar.gz
RUN wget https://github.com/Arachni/arachni/releases/download/v1.6.1/${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf ${ARACHNI_VERSION}-linux-x86_64.tar.gz && \
    mv ${ARACHNI_VERSION}/ /usr/local/arachni && \
    rm -rf *.tar.gz

COPY "$PWD"/files /
EXPOSE 22 7331 9292 8888 8000-20000

CMD entrypoint.sh
