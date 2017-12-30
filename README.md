
### About this image

This is a sample docker container is used to test OpenID Connect and OAuth2 with Nginx.

### How to use

1 - Sign-up for Okta https://developer.okta.com

2 - Register an authz server with a custom scope and a client app in Okta.

3 - Launch your docker container:

```bash
docker run -p 80:80 -p 443:443 -d \
-e OKTA_AUTHZ_SERVER='<YOUR_AUTHZ_SERVER_URL>' \
-e CLIENT_ID='<YOUR_CLIENT_ID>' \
-e CLIENT_SECRET='<YOUR_CLIENT_ID>' \
--name nginx-oidc fhakamine/nginx-oidc
```

4 - Go requestb.in and get a uri

5 - Go https://127.0.0.1.xip.io/<uri>

6 - Sign into Okta and see the ok page.

7 - Go requestb.in and check the results.

### Parameters

- OKTA_AUTHZ_SERVER: YOUR_OKTA_AUTHZ_SERVER_URL
- CLIENT_ID: YOUR_APP_CLIENT_ID
- CLIENT_SECRET: YOUR_APP_CLIENT_ID
- (Optional) HOST: your host (default: 127.0.0.1.xip.io)
- (Optional) REVERSE_ACCESS: your reverse proxy for https://host/ (default: https://requestb.in/)
- (Optional) REVERSE_API: your reverse proxy for https://host/api/ (default: https://requestb.in/)
- (Optional) API_SCOPE: your scope to protect https://host/api/ (default: reqbin:get)

### Specs

- The container runs Nginx with OpenResty, SSL (self-signed certificates), and lua-resty-openidc.
- Container runs as https://127.0.0.1.xip.io.
- OAuth uses the authorization code flow.
- The default redirect uri is https://127.0.0.1.xip.io/oidc_redirect
- The default logout uri is https://127.0.0.1.xip.io/oidc_logout
- The HTTP server provides 2 paths: / for UI reverse proxy (with OpenID Connect), and /api/ to API reverse proxy (with OAuth JWT validation).
- You can always work on your Docker/Apache-fu to customize the default behavior.


### How to run with Okta SSO

```bash
docker run -p 80:80 -p 443:443 -d \
-e OKTA_AUTHZ_SERVER='https://ice.okta.com' \
-e CLIENT_ID='1234' \
-e CLIENT_SECRET='secret' \
-e REVERSE_ACCESS='https://ui.internal.com' \
--name nginx-oidc fhakamine/nginx-oidc
```

### How to run with Okta API AM and a custom /api endpoint:

```bash
docker run -p 80:80 -p 443:443 -d \
-e OKTA_AUTHZ_SERVER='https://ice.okta.com/oauth2/123456' \
-e CLIENT_ID='1234' \
-e CLIENT_SECRET='secret' \
-e REVERSE_API='https://api.internal.com' \
-e REVERSE_API='api:read' \
--name nginx-oidc fhakamine/nginx-oidc
```

### Additional tricks

To run with custom URL and certificates:

```bash
docker run -p 80:80 -p 443:443 -d \
-v /my/private/server.key:/etc/ssl/certs/nginx_server.key \
-v /my/public/server.crt:/etc/ssl/certs/nginx_server.crt \
-e HOST='https://mycustomhost.com'
...
```

To run with custom config:

```bash
docker run -p 80:80 -p 443:443 -d \
-v /my/custom/conf/default.conf:/etc/nginx/conf.d/default.conf \
...
```

### Support

This container is provided “AS IS” with no express or implied warranty for accuracy or accessibility. This container intended to demonstrate the basic integration between HTTP servers with OIDC and does not represent, by any means, the recommended approach or is intended to be used in development or productions environments.

### Links

https://github.com/zmartzone/lua-resty-openidc
https://github.com/openresty/docker-openresty
