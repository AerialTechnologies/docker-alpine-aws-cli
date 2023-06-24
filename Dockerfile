# Alpine 3.18.2 is current latest
ARG ALPINE_VERSION=3.18

# Nomad client builder
FROM golang:alpine${ALPINE_VERSION} as nomad_builder

ARG NOMAD_VERSION=1.5.6

ADD https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip .
RUN apk add --no-cache --virtual .build-deps git build-base cmake bash musl-dev linux-headers && \
    mkdir -p $GOPATH/src/github.com/hashicorp && cd $_ && \
    git clone --single-branch -b v${NOMAD_VERSION} https://github.com/hashicorp/nomad.git && \
    cd nomad && make bootstrap && \
    make dev && \
    apk del .build-deps

# Clean up nomad repo
RUN cd .. && rm -rf nomad


# -------------

# AWS CLI builder
FROM python:3.10-alpine${ALPINE_VERSION} as awscli_builder

ARG AWS_CLI_VERSION=2.12.0

RUN apk add --no-cache --virtual .build-deps git unzip groff build-base libffi-dev cmake && \
    git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git

WORKDIR aws-cli
RUN ./configure --with-install-type=portable-exe --with-download-deps \
    && make \
    && make install

# reduce image size: remove autocomplete and examples
RUN rm -rf \
    /usr/local/aws-cli/v2/current/dist/aws_completer \
    /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/current/dist/awscli/examples && \
    apk del .build-deps

# ------------

# Helm builder
FROM alpine:${ALPINE_VERSION} as helm_builder

ARG HELM_VERSION=3.11.0
RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -f helm-v${HELM_VERSION}-linux-amd64.tar.gz

# ------------

# build the final image
FROM alpine:${ALPINE_VERSION} as main

# Comment/Uncomment the tools you need in the final image
COPY --from=awscli_builder /usr/local/lib/aws-cli/ /usr/local/bin/
COPY --from=helm_builder /usr/bin/helm /usr/local/bin/
COPY --from=nomad_builder /go/bin/nomad /usr/local/bin/

RUN apk add --no-cache git bash

# Expose .aws to mount config/credentials
VOLUME /root/.aws
