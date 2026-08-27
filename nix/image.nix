{ lib
, dockerTools
, nginx
, writeText
, site
, name ? "website"
, tag ? "dev"
}:

let
  nginxConf = writeText "nginx.conf" ''
    user nobody nogroup;
    worker_processes auto;
    error_log /dev/stderr warn;
    pid /tmp/nginx.pid;

    events {
      worker_connections 1024;
    }

    http {
      include ${nginx}/conf/mime.types;
      default_type application/octet-stream;
      access_log /dev/stdout;

      client_body_temp_path /tmp/client_body;
      proxy_temp_path /tmp/proxy;
      fastcgi_temp_path /tmp/fastcgi;
      uwsgi_temp_path /tmp/uwsgi;
      scgi_temp_path /tmp/scgi;

      sendfile on;
      tcp_nopush on;
      keepalive_timeout 65;
      server_tokens off;

      server {
        listen 80;
        listen [::]:80;

        root ${site};
        index index.html;
        error_page 404 /404.html;

        location / {
          try_files $uri $uri/ =404;
        }
      }
    }
  '';
in
dockerTools.streamLayeredImage {
  inherit name tag;

  contents = [
    dockerTools.fakeNss
    dockerTools.caCertificates
  ];

  extraCommands = ''
    mkdir -p tmp var/log/nginx var/cache/nginx
    chmod 1777 tmp
  '';

  config = {
    Cmd = [ "${lib.getExe nginx}" "-c" "${nginxConf}" "-e" "/dev/stderr" "-g" "daemon off;" ];
    ExposedPorts = { "80/tcp" = { }; };
    WorkingDir = "/";
  };
}
