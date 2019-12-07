FROM php:7.0-apache-jessie
MAINTAINER Ayupov Ayaz

RUN apt-get update && apt-get install -y apt-transport-https nano &&\
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - &&\
  curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev &&\

  pecl install pdo_sqlsrv \
    && docker-php-ext-enable pdo_sqlsrv \
    && apt-get autoremove -y && apt-get clean &&\

  # install necessary locales
  apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

EXPOSE 80
