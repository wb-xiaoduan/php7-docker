FROM php:7.1-apache

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

 
	
RUN apt-get update && apt-get install -y \
mssql-tools \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    unixodbc-dev \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install opcache \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install mbstring \
    && rm -r /var/lib/apt/lists/*
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

RUN pecl install sqlsrv \
    && pecl install pdo_sqlsrv
    
RUN cd /usr/local/bin \
	./docker-php-ext-install pdo_mysql \
	&& docker-php-ext-enable pdo_mysql sqlsrv pdo_sqlsrv 

RUN cd /usr/local/bin \
	&& curl -sS https://getcomposer.org/installer | php \
	&& php composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && chmod 744 composer

EXPOSE 80 
WORKDIR /app 
