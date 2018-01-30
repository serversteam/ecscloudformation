#!/bin/bash

service apache2 start
touch /var/log/syslog
tailf /var/log/syslog
echo "this is test" > /var/www/html/abc.txt
