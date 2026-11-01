# syntax=docker/dockerfile:1

# Same Python as upstream's server/Dockerfile.
FROM docker.io/library/python:3.12-slim
ARG VERSION
ENV \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    HOME=/tmp \
    MEM0_DIR=/tmp/.mem0 \
    HISTORY_DB_PATH=/data/history.db
ADD https://github.com/mem0ai/mem0.git#v${VERSION} /tmp/src
# Install the library from the same tag as the server: requirements.txt only asks for mem0ai>=0.1.48.
RUN \
    pip install /tmp/src -r /tmp/src/server/requirements.txt \
    && mkdir -p /app /data \
    && cp -a /tmp/src/server/. /app/ \
    && rm -rf /tmp/src /app/dashboard \
    && chown nobody:nogroup /data
COPY . /
WORKDIR /app
USER nobody:nogroup
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
