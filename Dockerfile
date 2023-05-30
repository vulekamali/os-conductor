FROM python:3.6-alpine3.15

WORKDIR /app

RUN apk add --update --no-cache \
    libpq \
    postgresql-dev \
    libffi \
    libffi-dev \
    bash \
    curl \
    libstdc++ \
    nodejs \
    && apk --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --update add \
    leveldb \
    leveldb-dev

COPY requirements.txt .

RUN apk add --update --no-cache --virtual=build-dependencies \
    build-base \
    git \
    npm \
    && pip install setuptools==45 \
    && pip install -r requirements.txt

# package and install locally
RUN git clone https://github.com/vulekamali/os-types.git \
    && cd os-types \
    && git checkout 424e46e \
    && npm install \
    && npm run build \
    && npm pack \
    && npm install -g os-types-1.15.2.tgz

COPY config.yml config.yml
COPY docker/startup.sh /startup.sh
COPY docker/docker-entrypoint.sh /entrypoint.sh
COPY conductor conductor

EXPOSE 8000

CMD ["/startup.sh"]
ENTRYPOINT ["/entrypoint.sh"]
