FROM ubuntu:16.04

#update all packages
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y autoremove && \
    apt-get clean

RUN apt-get install -y elinks curl graphicsmagick
RUN apt-get install -y python-software-properties -y
RUN apt-get install -y software-properties-common python-software-properties -y
RUN add-apt-repository ppa:git-core/ppa -y
RUn LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get -y update
RUN apt-get install -y apache2
RUN apt-get install -y php7.1 libapache2-mod-php mcrypt php7.1-mcrypt php-mysql
RUN a2enmod rewrite

# Tidy up
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get install php-mysql -y
RUN mkdir /var/www/html/laravel
RUN apt-get update -y
COPY app/ /app/
COPY test.txt /var/www/html/
RUN chmod +x /app/init.sh
RUN apt-get install -y composer
RUN apt-get install -y php-mbstring  php-xml php-curl
EXPOSE 80

ENTRYPOINT ["/app/init.sh"]

#RUN /etc/init.d/apache2 start
