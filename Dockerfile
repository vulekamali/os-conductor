FROM python:3.6-alpine

RUN apk add --update --no-cache \
    git \
    libpq \
    postgresql-dev \
    libffi \
    libffi-dev \
    bash \
    curl \
    libstdc++ \
    nodejs \
    nodejs-npm
RUN apk add --update --no-cache --virtual=build-dependencies build-base
RUN apk --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --update add leveldb leveldb-dev

WORKDIR /app
ADD requirements.txt .
RUN pip install -r requirements.txt

# Install os-types, used in the loading process for fiscal modelling the datapackage
RUN npm install -g os-types@1.15.1

RUN apk del build-dependencies
RUN rm -rf /var/cache/apk/*

COPY config.yml config.yml

COPY docker/startup.sh /startup.sh
COPY docker/docker-entrypoint.sh /entrypoint.sh

COPY conductor conductor

# ADD repos/dpp-runner repos/dpp-runner
# RUN pip install -e repos/dpp-runner

EXPOSE 8000

CMD ["/startup.sh"]
ENTRYPOINT ["/entrypoint.sh"]
