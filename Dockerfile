FROM ubuntu:16.04

#update all packages
RUN apt-get update && \
    apt-get -y autoremove && \
    apt-get clean
RUN apt-get install -y apache2


COPY app/ /app/
COPY test.txt /var/www/html/
RUN chmod +x /app/init.sh
EXPOSE 80

ENTRYPOINT ["/app/init.sh"]

#RUN /etc/init.d/apache2 start
