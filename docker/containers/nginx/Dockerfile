# specifies the base image from which we are building
FROM debian:jessie

# install nginx with extra modules (like Lua)
RUN apt-get update && apt-get install -y nginx nginx-extras

LABEL maintainer="@FligFlug"

# add self-signed SSL certificate
RUN mkdir /etc/nginx/cert
COPY cert/* /etc/nginx/cert/

# add custom configuration for Nginx
COPY nginx.conf /etc/nginx/

# add virtual host for Symfony
COPY vhost.symfony.conf /etc/nginx/sites-available/

# activate the host by creating a symbolic link between the sites-available directory and the sites-enabled directory
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/sites-available/vhost.symfony.conf /etc/nginx/sites-enabled/vhost

# run with daemon off ot resolve 'exited with status 0 issue', because it keeps Nginx running in the foreground
CMD ["nginx", "-g", "daemon off;"]