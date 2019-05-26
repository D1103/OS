FROM ubuntu
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get clean 
RUN apt-get install -qy nginx
RUN rm -rf /var/www/
ADD index.html /var/www/company.com/
ADD img.jpg /var/www/company.com/img/
RUN chmod -R 754 /var/www/company.com
RUN useradd daniil
RUN groupadd yakovlev
RUN usermod -g yakovlev daniil
RUN chown daniil:yakovlev /var/www/company.com
RUN sed -i 's~/var/www/html~/var/www/company.com~g' /etc/nginx/sites-enabled/default
RUN sed -i 's/www-data/daniil/g' /etc/nginx/nginx.conf
RUN service nginx restart
 
