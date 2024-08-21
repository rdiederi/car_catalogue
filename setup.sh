#!/bin/bash

check_command() {
    command -v "$1" >/dev/null 2>&1 || { echo >&2 "Error: $1 is required but not installed. Aborting."; exit 1; }
}

check_php_version() {
    php_version=$(php -v | head -n 1 | awk '{print $2}')
    required_php_version="7.4"
    if [ "$(printf '%s\n' "$required_php_version" "$php_version" | sort -V | head -n1)" != "$required_php_version" ]; then 
        echo "Error: PHP version $required_php_version or higher is required. Found version $php_version."
        exit 1
    fi
}

check_mysql_mariadb() {
    if command -v mysql >/dev/null 2>&1; then
        mysql_version=$(mysql --version | awk '{print $5}' | awk -F\, '{print $1}')
        echo "MySQL/MariaDB version $mysql_version found."
    else
        echo "Error: MySQL or MariaDB is required but not installed. Aborting."
        exit 1
    fi
}

check_or_install_composer() {
    if command -v composer >/dev/null 2>&1; then
        echo "Composer is already installed."
    else
        echo "Composer is not installed. Installing Composer..."
        EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        ACTUAL_CHECKSUM="$(php -r 'echo hash_file("sha384", "composer-setup.php");')"

        if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
            echo 'ERROR: Invalid installer checksum'
            rm composer-setup.php
            exit 1
        fi

        php composer-setup.php --install-dir=/usr/local/bin --filename=composer
        RESULT=$?
        rm composer-setup.php
        if [ $RESULT -ne 0 ]; then
            echo "Composer installation failed."
            exit 1
        else
            echo "Composer installed successfully."
        fi
    fi
}

check_command php
check_command mysql
check_php_version
check_mysql_mariadb

echo "All system requirements are met."


if [ -f .env ]; then
    echo ".env file already exists. Skipping creation."
else
    cat <<EOF > .env
DB_HOST=localhost
DB_NAME=car_catalogue
DB_USER=car_catalogue_user
DB_PASS=car_catalogue_password
EOF
    echo ".env file created successfully."
fi

check_or_install_composer

composer install

read -p "Enter MySQL root username: " rootuser
echo -n "Enter MySQL root password: "
read rootpass

mysql -u"$rootuser" -p"$rootpass" -e "EXIT" 2>/dev/null

if [ $? -ne 0 ]; then
    echo "Invalid MySQL root username or password. Please try again."
    exit 1
fi

check_existing_values=$(mysql -u"$rootuser" -p"$rootpass" -e "
USE car_catalogue;
SELECT 1 FROM cars WHERE name = 'Toyota' AND model = 'Corolla' AND price = 18000.00 LIMIT 1;
SELECT 1 FROM users WHERE username = 'admin' LIMIT 1;" 2>/dev/null)

if [ "$check_existing_values" ]; then
    echo "Error: Default values already exist in the database."
    exit 1
fi

mysql -u"$rootuser" -p"$rootpass" -e "CREATE USER IF NOT EXISTS 'car_catalogue_user'@'localhost' IDENTIFIED BY 'car_catalogue_password';" 2>/dev/null

mysql -u"$rootuser" -p"$rootpass" -e "GRANT ALL PRIVILEGES ON car_catalogue.* TO 'car_catalogue_user'@'localhost';"
mysql -u"$rootuser" -p"$rootpass" -e "FLUSH PRIVILEGES;"

admin_password_hash=$(php -r "echo password_hash('password', PASSWORD_BCRYPT);")

sql_script=$(cat <<EOF
CREATE DATABASE IF NOT EXISTS car_catalogue;

USE car_catalogue;

CREATE TABLE IF NOT EXISTS cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    model VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    date_loaded DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);

INSERT INTO cars (name, model, price) VALUES ('Toyota', 'Corolla', 18000.00);
INSERT INTO cars (name, model, price) VALUES ('Honda', 'Civic', 20000.00);
INSERT INTO cars (name, model, price) VALUES ('Ford', 'Focus', 22000.00);

-- Add default user 'admin' with password 'password'
INSERT INTO users (username, password) VALUES ('admin', '$admin_password_hash');

EOF
)

mysql -u"$rootuser" -p"$rootpass" -e "$sql_script"

echo "Database and user setup completed successfully."

