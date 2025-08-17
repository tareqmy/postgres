FROM postgres:17.5
LABEL creator="Tareq Mohammad Yousuf"
LABEL email="tareq.y@gmail.com"

# Install gosu (used by official postgres image to drop root)
RUN apt-get update && apt-get install -y gosu && rm -rf /var/lib/apt/lists/*

# Copy scripts
COPY ./scripts/*.sh /
COPY ./scripts/initdb/*.sh /docker-entrypoint-initdb.d/
RUN chmod +x /*.sh
RUN chmod +x /docker-entrypoint-initdb.d/*.sh

# Set timezone
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/UTC /etc/localtime

# Entrypoint comes from the base image, CMD stays as postgres
CMD ["postgres"]
