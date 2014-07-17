## TODO

* Production level security.
* Audit by a Persona familiar dev.
* Don't spawn examples.

## Readme

Before you start, you'll need:

* `docker`
* Some time. :)
* (Optional) A `config` folder for with a configuration file. (See below)
* (Optional) An ENV file. (See below)

## Invocation:

You can pass the container any option you'd normally pass to `npm`, like `start`, `install`, `test`, etc.

### Example: Development

First, MySQL (make sure to change the password):

```bash
MYSQL_PASSWORD=foo
DB_NAME=persona-db
docker run --name $DB_NAME -e MYSQL_ROOT_PASSWORD=$MYSQL_PASSWORD -d mysql
docker run -it \
           --link $DB_NAME:mysql \
           --rm --volume=$(pwd):/docker_host \
       mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /docker_host/sql_startup_file'
```


Then, Persona:

```bash
docker run --publish=10001:10001 \
           --publish=10002:10002 \
           --name=persona \
           --hostname=persona.localhost \
           --env-file=$(pwd)/envfile \
           --link=$DB_NAME:database \
           --volume=$(pwd)/config:/home/persona/config \
       hoverbear/persona start
```

### Example: Testing

```bash
# TODO
```

### Example: Deployment

```bash
# TODO
```

### Example: Fiddle Shell

```bash
docker run --rm=true \
           # ... Other opts.
           -ti
           --entrypoint="/bin/bash" \
       hoverbear/persona -l
```

## SQL File

Your `sql_startup_file` should contain something like:

```sql
CREATE USER 'browserid'@'%' IDENTIFIED BY 'browserid';
GRANT ALL ON *.* TO 'browserid'@'%';
FLUSH PRIVILEGES;
```
*You should actually specify a domain instead of '%'*

## ENV File

Create a file containing any environment settings you might want.

Example envfile:

```bash
CONFIG_FILES=/home/persona/config/config.json
HOST=127.0.0.1
MYSQL_USER=browserid
MYSQL_PASSWORD=browserid
DATABASE_NAME=browserid
```

## Config File

* Make a folder (Example: `$PERSISTENT_DIR/config/`) and mount it as a volume on `/home/persona/config`.
* Set an ENV variable (either via `-e` or in your `envfile`) of `CONFIG_FILES`

Example configuration:

```json
{
  "database": {
    "driver": "mysql",
    "host": "database"
  }
}
```

## SELinux
Using a RHEL derivative? Getting `EACCES` errors?

```bash
chcon -Rt svirt_sandbox_file_t $(pwd)
```
