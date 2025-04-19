#!/usr/bin/env bash
set -e

# STEP 1 – INSTALL NGINX
sudo apt update
sudo apt install nginx -y
sudo systemctl status nginx
curl http://localhost:80
curl http://<Public-IP-Address>:80

# STEP 2 – INSTALL MYSQL
sudo apt install mysql-server -y
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1';"
sudo mysql_secure_installation
sudo mysql -p

# STEP 3 – INSTALL PHP
sudo apt install php-fpm php-mysql -y

# STEP 4 – CONFIGURE NGINX FOR PHP
sudo mkdir -p /var/www/projectLEMP
sudo chown -R $USER:$USER /var/www/projectLEMP
sudo tee /etc/nginx/sites-available/projectLEMP > /dev/null << 'EOF'
server {
    listen 80;
    server_name projectLEMP www.projectLEMP;
    root /var/www/projectLEMP;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
    location ~ /\.ht {
        deny all;
    }
}
EOF
sudo ln -s /etc/nginx/sites-available/projectLEMP /etc/nginx/sites-enabled/
sudo nginx -t
sudo unlink /etc/nginx/sites-enabled/default
sudo systemctl reload nginx
sudo bash -c "echo 'Hello LEMP from hostname $(curl -s http://169.254.169.254/latest/meta-data/public-hostname) with public IP $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)' > /var/www/projectLEMP/index.html"

# STEP 5 – TEST PHP
sudo tee /var/www/projectLEMP/info.php > /dev/null << 'EOF'
<?php
phpinfo();
?>
EOF
sudo rm /var/www/projectLEMP/info.php

# STEP 6 – MYSQL + PHP TODO LIST
sudo mysql -e "CREATE DATABASE example_database;"
sudo mysql -e "CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'PassWord1@';"
sudo mysql -e "GRANT ALL ON example_database.* TO 'example_user'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -u example_user -p -e "SHOW DATABASES;"
sudo mysql -u example_user -p -e "CREATE TABLE example_database.todo_list (item_id INT AUTO_INCREMENT, content VARCHAR(255), PRIMARY KEY(item_id));"
sudo mysql -u example_user -p -e "INSERT INTO example_database.todo_list (content) VALUES ('My first important item');"
sudo mysql -u example_user -p -e "SELECT * FROM example_database.todo_list;"
sudo tee /var/www/projectLEMP/todo_list.php > /dev/null << 'EOF'
<?php
\$user = 'example_user';
\$password = 'password';
\$database = 'example_database';
\$table = 'todo_list';
try {
    \$db = new PDO('mysql:host=localhost;dbname=' . \$database, \$user, \$password);
    echo '<h2>TODO</h2><ol>';
    foreach (\$db->query('SELECT content FROM ' . \$table) as \$row) {
        echo '<li>' . \$row['content'] . '</li>';
    }
    echo '</ol>';
} catch (PDOException \$e) {
    print 'Error!: ' . \$e->getMessage() . '<br/>';
    die();
}
?>
EOF
