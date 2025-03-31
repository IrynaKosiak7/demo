server{
    listen 80;
    server_name example.com
    root /usr/share/nginx/html;
    index index.html;

    location /{
        try_files $uri/index.html;
    }
    location /api1/ {
        proxy_pass http://localhost:8080/api/hello;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
    location /api2/ {
        proxy_pass http://localhost:8080/api/chao;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

}