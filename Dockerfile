FROM alpine:3.13

ARG AZURE_CLI_VERSION=2.18.0

# Install python/pip
RUN apk add --no-cache curl tar openssl sudo bash jq python3 py3-pip
RUN apk add --virtual=build gcc libffi-dev musl-dev openssl-dev make python3-dev
RUN pip3 install virtualenv &&\
    python3 -m virtualenv /azure-cli
# Install azure-cli
RUN /azure-cli/bin/python -m pip install --upgrade pip
RUN /azure-cli/bin/python -m pip --no-cache-dir install azure-cli==${AZURE_CLI_VERSION}

RUN echo -e $'#!/usr/bin/env sh\n/azure-cli/bin/python -m azure.cli "$@"' > /usr/bin/az && chmod a+x /usr/bin/az

ENTRYPOINT ["/bin/sh", "-c"]
