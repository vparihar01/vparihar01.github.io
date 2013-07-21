# Setting up Unicorn with Nginx for Zero-Downtime deployment - by Github
Unicorn is a traditional UNIX(which makes great use of Unix) prefork web server.No threads are used at all, this makes applications easier to debug and fix.
## Deploying
With Unicorn one can deploy with zero downtime. From Unicorn documetation:

> You can upgrade Unicorn, your entire application, libraries and even your Ruby interpreter without dropping clients.

##  Rails on Unicorns
Now we start setting up rails up using ngnix with unicorn.

###  Installing Nginx
To install Nginx web server on our ubuntu server:
```
$ sudo apt-get install nginx
```

> We could start the server with the nginx command but the installer also installs an init.d file that we can use to manage our nginx server as well.

```
$ /etc/init.d/nginx -h
Usage: nginx {start|stop|restart|reload|force-reload|status|configtest}
```

We can run this`init.d` command directly or we can interact with it through the service command and we’ll use this to start it up.
```
$ sudo service nginx start
Starting nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
configuration file /etc/nginx/nginx.conf test is successful nginx.
```

### Configuring nginx to run on a port => 80
All main configuration file reside at `/etc/nginx/nginx.conf` and by default it looks like this:
```
$ cat /etc/nginx/nginx.conf
user nobody nogroup; # for systems with a "nogroup"
worker_processes  1;

error_log  /var/log/nginx/error.log;
pid        /var/run/nginx.pid;

events {
    worker_connections  1024;
    # multi_accept on;
}

http {
    include       /etc/nginx/mime.types;

    access_log        /var/log/nginx/access.log;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;
    tcp_nodelay        on;

    gzip  on;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```
In `nginx.conf` you may have stumbled upon this line:

> user nobody nogroup; # for systems with a "nogroup"

It’s generally adviced to run as a seperate user for security reasons and increased control. We’ll create an nginx user and a web group.

```
$ sudo useradd -s /sbin/nologin -r deploy
$ sudo usermod -a -G deploy deploy
```

Configure your static path in `nginx.conf` to `/var/www`, and change the owner of that directory to the web group:
```
$ sudo mkdir /var/www
$ sudo chgrp -R deploy /var/www # set /var/www owner group to "deploy"
$ sudo chmod -R 775 /var/www # group write permission
```
> To avoid permission issues we’re going to make Nginx run as “deploy”, the user that’s going to deploy the application code, this way we can rest safely that no “permission denied” on files will ever happen (at least as long as we don’t deploy as another user).

Now change this default `nginx.conf` file like this:
```
user  deploy deploy; 
worker_processes  1;
worker_priority  -5;
timer_resolution  100ms;
 
error_log  /var/log/nginx/error.log;
 
# To enable to open as many files as possible within a single nginx worker process without crashing increase default 1024 value to some higher value
worker_rlimit_nofile 30240;

events {
    use  epoll;
    worker_connections  10240;
}
 
 
http {
    client_header_buffer_size 1460;
    client_body_timeout  1460;
    client_max_body_size      25m;
    client_body_buffer_size   128k;
    client_body_temp_path     /tmp/client_body_temp;
    large_client_header_buffers 8 8m; 
 
    include                   mime.types;
    default_type              application/octet-stream;
    keepalive_timeout         1300;
 
    gzip                      on;
    gzip_http_version         1.1;
    gzip_disable              "msie6";
    gzip_vary                 on;
    gzip_min_length           500; #Compress everything no matter the size
    gzip_buffers              64 8k;
    gzip_comp_level           3;
    gzip_proxied              any;
    gzip_types                text/plain text/css application/x-javascript text/xml application/xml;
 
 
   
    proxy_connect_timeout  300;
    proxy_send_timeout  300;
    proxy_read_timeout  300;
    proxy_buffering on;
    proxy_buffers 8 16k;
    proxy_buffer_size 32k;

 

    # For better performance we use Linux sendfile():
    sendfile       on;

    # To send all response headers in one packet. This allows a client to start rendering content immediately after the first packet arrives:
    tcp_nopush     on;
    tcp_nodelay    off;
    
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
 
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;

}
```

To run a single application in this server, we can go on and edit the `/etc/nginx/sites-available/default` file directly, if you’re going to host more than one application in this server you should create separate files for each of them and then symlink them to the `/etc/nginx/sites-enabled/` folder.

Add a new file `unicorn_rails_app.conf` in the site-available directory and copy and paste the following into it:

```
upstream unicorn_rails_app {
    # fail_timeout=0 means we always retry an upstream even if it failed
    # to return a good HTTP response (in case the Unicorn master nukes a
    # single worker for timing out).

    # for UNIX domain socket setups:
  server unix:/var/www/rails_app/current/tmp/unicorn.rails_app.sock fail_timeout=0;
}

server {
  # if you're running multiple servers, instead of "default" you should
  # put your main domain name here
  listen 80 default;
  
  # you could put a list of other domain names this application answers
  server_name your.domain_name.com;
  
  # path for static files
  root /var/www/rails_app/current/public;
  access_log /var/log/nginx/rails_app_access.log;
  
  location / {
    proxy_pass http://unicorn_rails_app;            
    proxy_redirect     off;
 
    proxy_set_header   Host             $host:$proxy_port;
    proxy_set_header   X-Real-IP        $remote_addr;
    client_max_body_size 4m;
  #  proxy_ignore_client_abort on;
  }
  # if the request is for a static resource, nginx should serve it directly
  # and add a far future expires header to it, making the browser
  # cache the resource and navigate faster over the website
  location ~ ^/(images|javascripts|stylesheets|system)/  {
     root /var/www/rails_app/current/public;
     add_header Last-Modified "";
     add_header ETag "";
     expires max;
     break;
  }
  # Rails error pages
  error_page 500 502 503 504 /500.html;
  location = /500.html {
    root /path/to/app/current/public;
  }
}
```
After creating this new file `unicorn_rails_app.conf`, we need to symlink it to the sites-enabled directory:
```
$ sudo ln -s /etc/nginx/sites-available/unicorn_rails_app.conf /etc/nginx/sites-enabled/unicorn_rails_app.conf
```
### Unicorn setup
Now we have nginx running. Install the Unicorn gem:
```
$ gem install unicorn
```
Add the unicorn gem to your Rails application’s Gemfile

#### Gemfile
> source 'https://rubygems.org'

> gem 'rails', '3.2.12'

> gem 'unicorn'

#### Create the Unicorn configuration file in your Rails’ application `config/unicorn.rb` (copy the below lines):
```
$ vim config/unicorn.rb

# Unicorn configuration file to be running by unicorn_init.sh with capistrano task
# read an example configuration before: http://unicorn.bogomips.org/examples/unicorn.conf.rb
# 
# working_directory, pid, paths - internal Unicorn variables must to setup
# worker_process 4              - is good enough for serve small production application
# timeout 30                    - time limit when unresponded workers to restart
# preload_app true              - the most interesting option that confuse a lot of us,
#                                 just setup is as true always, it means extra work on 
#                                 deployment scripts to make it correctly
# BUNDLE_GEMFILE                - make Gemfile accessible with new master
# before_fork, after_fork       - reconnect to all dependent services: DB, Redis, Sphinx etc.
#                                 deal with old_pid only if CPU or RAM are limited enough
#
# config/server/production/unicorn.rb
 
 
app_path          = "/var/www/rails_app/current"
 
working_directory "#{app_path}"
pid               "#{app_path}/tmp/pids/unicorn.pid"
stderr_path       "#{app_path}/log/unicorn.log"
stdout_path       "#{app_path}/log/unicorn.log"
 
listen            "#{app_path}/tmp/unicorn.rails_app.sock" , :backlog => 64

user 'deploy','deploy'
#listen 80, :tcp_nopush => true 
#listen 8080, :tcp_nopush => true
worker_processes  4
timeout           600
preload_app       true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end
```
> Then Unicorn is configured!

#### Create a Unicorn initializer shell script in the `/var/www/rails_app/current/config` directory to start|stop|restart unicorn processes:
```
$ touch /var/www/rails_app/current/config/unicorn

$ vim /var/www/rails_app/current/config/unicorn
```
#### Paste the following into that new file:

```
#! /bin/bash

### BEGIN INIT INFO
# Provides:          unicorn
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the unicorn web server
# Description:       starts unicorn
### END INIT INFO

APP_ROOT="/var/www/rails_app"
USER="deploy"
DAEMON=unicorn_rails
DAEMON_OPTS="-c $APP_ROOT/shared/config/unicorn.rb -E staging -D"
NAME=unicorn
DESC="Unicorn app for $USER"
PID=$APP_ROOT/shared/pids/unicorn.pid

case "$1" in
  start)
        CD_TO_APP_DIR="cd $APP_ROOT"
        START_DAEMON_PROCESS="bundle exec $DAEMON $DAEMON_OPTS"

        echo -n "Starting $DESC: "
        if [ `whoami` = root ]; then
          su - $USER -c "$CD_TO_APP_DIR > /dev/null 2>&1 && $START_DAEMON_PROCESS"
        else
          $CD_TO_APP_DIR > /dev/null 2>&1 && $START_DAEMON_PROCESS
        fi
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        kill -QUIT `cat $PID`
        echo "$NAME."
        ;;
  restart)
        echo -n "Restarting $DESC: "
        kill -USR2 `cat $PID`
        echo "$NAME."
        ;;
  reload)
        echo -n "Reloading $DESC configuration: "
        kill -HUP `cat $PID`
        echo "$NAME."
        ;;
  *)
        echo "Usage: $NAME {start|stop|restart|reload}" >&2
        exit 1
        ;;
esac

exit 0
```
#### Start nginx server
Start your nginx server from its installation directory:
```
$ /etc/init.d/nginx restart
```
#### Start Unicorn server
Start your Unicorn server from your Rails application directory, with no port specified (it will use the Unix socket from its configuration instead):

```
$ unicorn_rails -E production -D -c /var/www/rails_app/current/config/unicorn.rb
```