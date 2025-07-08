ARG TAG="latest"
FROM postgres:${TAG}
LABEL creator="Tareq Mohammad Yousuf"
LABEL email="tareq.y@gmail.com"

# Install gosu (used by official postgres image to drop root)
RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

COPY ./scripts/*.sh /
COPY ./scripts/entry-point.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod +x /docker-entrypoint-initdb.d/init.sh
COPY .env /
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
    && chmod +x /entry-point.sh

# This will be the argument for entrypoint eg: /entry-point.sh postgres
CMD ["postgres"]
