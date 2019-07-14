FROM postgres:latest
LABEL creator="Tareq Mohammad Yousuf"
LABEL email="tareq.y@gmail.com"

COPY *.sh /
RUN rm -f /etc/localtime \
    && ln -s /usr/share/zoneinfo/UTC /etc/localtime

CMD ["postgres"]
