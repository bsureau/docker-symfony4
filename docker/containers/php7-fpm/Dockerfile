# specifies the base image from which we are building
FROM php:7.2-fpm

LABEL maintainer="@FligFlug"

ARG APP_PROJECT_DIR_NAME

WORKDIR /var/www/project/${APP_PROJECT_DIR_NAME}

# install PDO MySQL extension
RUN docker-php-ext-install pdo_mysql