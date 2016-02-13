#!/bin/bash
apt-get install -y nginx
if [ ! -f /etc/nginx/conf.d/digits.conf ]; then
    echo "Setting up NginX conf for nVidiaDigits..."
    cat <<'EOF' > /etc/nginx/conf.d/digits.conf
server {
  listen 80;
# Update servername once DNS mapping is present
# server_name digits;

  access_log  /var/log/nginx/digits_access.log;
  error_log   /var/log/nginx/digits_error.log;

  location / {
      proxy_pass http://localhost:5000;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP  $remote_addr;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_cache_bypass $http_upgrade;
  }
}
EOF
   unlink /etc/nginx/sites-enabled/default
   service nginx restart
else
    echo "NginX conf for nVidiaDigits already exists!"
fi
