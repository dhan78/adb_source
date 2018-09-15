server {

	server_name adbanalytics.com;

	root /var/www/html/adb_source;
	index index.html;

	location / {
		if ($request_uri ~ ^/(.*)\.html$) {
		return 302 /$1;	
		} 
		try_files $uri $uri.html $uri/ =404;
	}
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	}

    listen [::]:443 ssl ipv6only=on; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/adbanalytics.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/adbanalytics.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}
server {
    if ($host = adbanalytics.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


	listen 80;
	listen [::]:80;

	server_name adbanalytics.com;
    return 404; # managed by Certbot


}
