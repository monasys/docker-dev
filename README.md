# docker-dev

A PHP/Laravel development environment.

This Docker project is set of pre-configured & lightweight containers made for PHP development.
The setup includes Composer, Xdebug, phpMyAdmin and utilizes Docker shared volumes to share your code between the container and your host system.

## Getting started

Create the `code` directory:

```console
$ mkdir code
```

Create the `.env` file:

```console
$ cp .env.example .env
```

* Put the user ID of your host system for the `UID` value. To find this, open a terminal and run: `id -u`. 
* Input in a password of your choice for `UNIX_PASSWD` and `MYSQL_PASSWD`.
* Input a database name for `MYSQL_DB_NAME`. This is the initial database - more can be created once the container is running.

Add the following entries to your `hosts` file:

```bash
127.0.0.1 dev.docker.internal
127.0.0.1 laravel.docker.internal
127.0.0.1 phpmyadmin.docker.internal
```

Start the containers:

```console
$ docker-compose up -d
```
The primary container is `docker-dev-php`. This runs as a non-root user to mitigate permission issues with shared volumes.

* Open a terminal on the main container: `docker exec -it docker-dev-php sh`
* Open a terminal on the MySQL container: `docker exec -it docker-dev-mysql bash -c "mysql -uroot -pPASSWORD"`
* MySQL is accessible on the host via port `33060`
* Your code is shared in `./code`

### Creating a new database

Open a terminal to the MySQL container:

```console
$ docker exec -it docker-dev-mysql bash -c "mysql -uroot -pPASSWORD"
```

Create the database:

```console
$ CREATE DATABASE dbname;
```

### Creating a new Laravel site

Open a terminal to the main container:

```console
$ docker exec -it docker-dev-php sh
```

Create the Laravel site in the default working directory: `/var/www/code/`

```console
$ composer create-project laravel/laravel example-app
```

Edit the `.env` file in the new Laravel project:

* Set `DB_HOST` value to `mysql`.
* Set `DB_PASSWORD` value to that of your MySQL password.

Run the database migration script:

```console
$ php artisan migrate
```

Access your new Laravel site: `http://laravel.docker.internal`

Access phpMyAdmin: `http://phpmyadmin.docker.internal`

Open the code in your favourite IDE: `./code/example-app`

### Vanilla PHP development

NGINX is configured to allow directory listing in the `./code` directory.

Place or clone each project in `./code` on your host and each directory will be accessible in the browser: `http://dev.docker.internal`

### Debugging
Xdebug is installed on the main container and port `9003` is exposed. To activate Xdebug, set the `XDEBUG_SESSION` cookie - this can be done with a handy bookmark from PhpStorm: https://www.jetbrains.com/phpstorm/marklets

Configure your IDE to accept incoming connections from Xdebug & set a breakpoint to step through the code.
* https://www.jetbrains.com/help/phpstorm/configuring-xdebug.html#integrationWithProduct

Often PhpStorm will automatically pick up a new incoming connection without any pre-configuration. 
