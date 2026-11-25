# Docker WordPress Blog

This project starts a three-container WordPress application:

- **MariaDB** — stores the WordPress database
- **phpMyAdmin** — provides a web interface for managing MariaDB
- **WordPress** — runs the WordPress website

The containers share the Docker network `blog`. Data is retained in the `blog-database` and `blog-wordpress` Docker volumes when the containers are stopped.

## Start the project

From this directory, run:

```bash
chmod +x setup.sh
./setup.sh start
```

Open:

- WordPress: <http://localhost:9091>
- phpMyAdmin: <http://localhost:9090>

## Stop the project

```bash
./setup.sh stop
```

This stops and removes the containers and removes the `blog` network. The named volumes and their data remain available.

## Remove the project

```bash
./setup.sh remove
```

This stops and removes the containers, removes the `blog` network, and deletes the `blog-database` and `blog-wordpress` volumes. Use this option only when you want to permanently delete the database and WordPress files.

## First-time database setup

The MariaDB container is configured with:

- Username: `root`
- Password: `password123`

Open phpMyAdmin at <http://localhost:9090> and log in using these credentials.

Use phpMyAdmin's GUI to create a database and user:

1. Select **Databases** from the top navigation.
2. Under **Create database**, enter `wordpress` as the database name.
3. Select `utf8mb4_unicode_ci` for the collation.
4. Click **Create**.
5. Open **User accounts** in the top navigation.
6. Click **Add user account**.
7. Enter `wordpress` as the **User name**.
8. Select `Any host` or enter `%` for **Host name** so the WordPress container can connect.
9. Enter and confirm a strong password.
10. Under **Database for user account**, select **Grant all privileges on the database `wordpress`**.
11. Click **Go** to create the account.

Keep the database name and password for the WordPress installer.

## First-time WordPress installation

Open <http://localhost:9091> and complete the WordPress setup screen. Enter:

- Database Name: `wordpress`
- Username: `wordpress`
- Password: the password used in the SQL command above
- Database Host: `db`
- Table Prefix: `wp_` or a custom prefix

Create the WordPress administrator account on the next screen. This account is separate from the MariaDB user and is used to sign in to the WordPress administration dashboard.

## Restarting

Run `./setup.sh start` after `./setup.sh stop` to retain existing data.

Run `./setup.sh start` after `./setup.sh remove` only to create a fresh project setup.
