# Docker Symfony starter

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

This is a complete stack for running Symfony 4 into Docker containers using docker-compose tool.

# 1. Configuration
First, clone this repository: 
```$ git clone git@github.com:fligflug/docker-symfony4.git```

Then, open your favorite IDE and edit the following lines in .env.dist file with your own project parameters:
```
# The project directory name
APP_PROJECT_DIR_NAME=sfstarter

# The server name (your url)
APP_SERVER_NAME=sfstarter.local
APP_SERVER_ALIAS=www.sfstarter.local

# Put here your database name, user and pwd
MYSQL_DATABASE=sfstarter
MYSQL_USER=root
MYSQL_PASS=root
```

# Install with Docker

Install Docker Compose if you haven't installed yet: ``` https://docs.docker.com/compose/install/#prerequisites ```

Then, from the root directory of your brand new Symfony project, run:
```
$ make          # makefile help
$ make install  # install and start the project
```

When you're done, don't forget to update your hosts: 
```
$ sudo [nano|vim|...]  /etc/hosts
# add the following line
127.0.0.1 [servername].local www.[servername].local
# servername must match with APP_SERVER_NAME in your .env.dist file (here, sfstarter.local)
```

# Test your website
```
http[s]://www.[servername].local/
```
You're now ready to code!
