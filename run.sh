#!/bin/bash

# SED will update the NGINX configuration
sed -ie 's|__HOST__|'"$HOST"'|g' /etc/nginx/conf.d/default.conf
sed -ie 's|__OKTA_AUTHZ_SERVER__|'"$OKTA_AUTHZ_SERVER"'|g' /etc/nginx/conf.d/default.conf
sed -ie 's|__CLIENT_ID__|'"$CLIENT_ID"'|g' /etc/nginx/conf.d/default.conf
sed -ie 's|__CLIENT_SECRET__|'"$CLIENT_SECRET"'|g' /etc/nginx/conf.d/default.conf
sed -ie 's|__REVERSE_ACCESS__|'"$REVERSE_ACCESS"'|g' /etc/nginx/conf.d/default.conf
sed -ie 's|__REVERSE_API__|'"$REVERSE_API"'|g' /etc/nginx/conf.d/default.conf
sed -ie 's|__API_SCOPE__|'"$API_SCOPE"'|g' /etc/nginx/conf.d/default.conf

# Start nginx (openresty)
/usr/local/openresty/bin/openresty -g 'daemon off;'
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi

# Check every 60s if nginx is running. If not, stop docker
while /bin/true; do
  ps aux | grep nginx
  NGINX_STATUS=$?
  echo $NGINX_STATUS
  if [ $NGINX_STATUS -ne 1 ]; then
    echo "NGINX already exited."
    exit -1
  fi
  sleep 60
done
