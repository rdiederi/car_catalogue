# Car Catalogue Project Setup

## Requirements
- PHP 7.4 or higher
- MySQL/MariaDB
- Composer 

## Project Setup

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd car_catalogue
   ```

2. **Run the setup script:**
   ```bash
   bash setup.sh
   ```
   This script will:
   - Check for required system dependencies.
   - Create the `car_catalogue` database and required tables.
   - Create a default user `admin` with the password `password`.

3. **Running the project:**
   Use PHP's built-in server to run the project:
   ```bash
   php -S localhost:8005
   ```
   Access the site at [http://localhost:8005](http://localhost:8005).

## Database Access
- **Username:** car_catalogue_user
- **Password:** car_catalogue_password
- **Database:** car_catalogue

## Default Admin Credentials
- **Username:** admin
- **Password:** password