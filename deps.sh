#!/bin/bash

set -o errexit
set -o pipefail

apt-get -q update
apt-get -y install php-fpm nginx && apt-get -y install mysql mysql-server php-mysql php-common php-gd php-mbstring php-mcrypt php-xml php-gd php-bcmath

if [ -e /etc/nginx/nginx.conf]
  then
  echo "Backup default NGINX Config"
  mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old

  echo "Make new NGINX Config"
  touch /etc/nginx/nginx.conf

  echo "Fill with content"
  echo "http {
  server {
   bash location / { 
          proxy_set_header X-Real-IP $remote_addr; 
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
          proxy_set_header Host $http_host; 
          proxy_set_header X-NginX-Proxy true; 
          proxy_pass http://127.0.0.1:8000/; 
          proxy_redirect off; 
      }
   listen       80;
   servername  ;
   access_log  logs/host.access.log  main;
   root   /var/www;
   index  index.php index.html index.htm;
   location ~ .php$ {
      # Security: must set cgi.fixpathinfo to 0 in php.ini!
      fastcgi_split_path_info ^(.+.php)(/.+)$;
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME          $document_root$fastcgi_script_name;
      fastcgi_param PATH_INFO $fastcgi_path_info;
      include /etc/nginx/fastcgi_params;
   }
  }
  }" >> /etc/nginx/nginx.conf
else
  echo "Make new NGINX Config"
  touch /etc/nginx/nginx.conf

  echo "Fill with content"
  echo "http {
  server {
   bash location / { 
          proxy_set_header X-Real-IP $remote_addr; 
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; 
          proxy_set_header Host $http_host; 
          proxy_set_header X-NginX-Proxy true; 
          proxy_pass http://127.0.0.1:8000/; 
          proxy_redirect off; 
      }
   listen       80;
   servername  ;
   access_log  logs/host.access.log  main;
   root   /data/timetable/www;
   index  index.php index.html index.htm;
   location ~ .php$ {
      # Security: must set cgi.fixpathinfo to 0 in php.ini!
      fastcgi_split_path_info ^(.+.php)(/.+)$;
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME          $document_root$fastcgi_script_name;
      fastcgi_param PATH_INFO $fastcgi_path_info;
      include /etc/nginx/fastcgi_params;
   }
  }
  }" >> /etc/nginx/nginx.conf
fi

echo "Install Monit"
apt-get -q update && apt-get -y install monit

if [ -e /etc/monit.d/timetable]
  then
  echo "Backup default Monit Script"
  mv /etc/monit.d/timetable /etc/monit.d/timetable.old

  echo "Make new Monit Script"
  touch /etc/monit.d/timetable

  echo "Fill Monit script"
  echo "bash check host timetable with address 127.0.0.1 start program = "/usr/local/bin/node /data/timetable/app.js" as uid node and gid node stop program = "/usr/bin/pkill -f 'node /data/timetable/app.js'" if failed port 8000 protocol HTTP request / with timeout 10 seconds then restart" >> /etc/monit.d/timetable
else
  echo "Make new Monit Script"
  touch /etc/monit.d/timetable

  echo "Fill Monit script"
  echo "bash check host timetable with address 127.0.0.1 start program = "/usr/local/bin/node /data/timetable/app.js" as uid node and gid node stop program = "/usr/bin/pkill -f 'node /data/timetable/app.js'" if failed port 8000 protocol HTTP request / with timeout 10 seconds then restart" >> /etc/monit.d/timetable
fi