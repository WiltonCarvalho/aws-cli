FROM ubuntu:22.04 as stg1
RUN apt-get update &&  apt-get --no-install-recommends -y install openjdk-17-jre-headless \
&& rm -rf /var/lib/apt/lists/*

FROM alpine as stg2
RUN apk add curl unzip
RUN curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip -o /tmp/awscliv2.zip
RUN unzip -q /tmp/awscliv2.zip -d /opt

FROM stg1
COPY --from=stg2 /opt/aws /opt/aws
RUN /opt/aws/install -i /usr/local/aws-cli -b /usr/local/bin --update \
&& rm -rf /opt/aws \
&& aws --version
