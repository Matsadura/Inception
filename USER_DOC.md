# User Documentation

This guide provides instructions for end users and administrators to operate the Inception stack.

## Services Provided by the Stack
The infrastructure provides the following services:
* **Web Server (Nginx):** The secure entry point serving the WordPress website over port `443`.
* **Content Management (WordPress):** The backend interface for publishing and managing website content.
* **Database (MariaDB):** Secure relational database storing all site data.
* **Object Cache (Redis):** Caches database queries in memory to speed up website load times, exposed on port `6379`.
* **File Transfer (FTP):** Allows administrators to upload files directly to the website's root directory via ports `21` and `21000-21010`.
* **Database Management (Adminer):** A lightweight graphical interface to inspect and modify the MariaDB database.
* **System Monitoring (cAdvisor):** Provides real-time graphs for CPU, memory, and network usage across all containers.
* **Static Website:** A standalone, simple website hosted separately from WordPress.

## Starting and Stopping the Project
Use the provided `Makefile` at the root of the repository to manage the stack.
* **Start Stack:** Run `make` or `make bonus`.
* **Stop Services:** Run `make down`.
* **Deep Clean (Wipe Data):** Run `make fclean`.

## Accessing Interfaces
Once the stack is running, you can access the following services via a web browser or terminal:
* **Main Website:** `https://zzaoui.42.fr` (Port `443`).
* **WordPress Admin Panel:** `https://zzaoui.42.fr/wp-admin/`
* **Static Website:** `http://zzaoui.42.fr:1212` (Port `1212`).
* **Adminer Database GUI:** `http://zzaoui.42.fr:8081` (Port `8081`).
* **cAdvisor Monitoring:** `http://zzaoui.42.fr:8080` (Port `8080`).
* **FTP Access:** `ftp zzaoui.42.fr` (Port `21`).

## Locating and Managing Credentials
For security, passwords are not hardcoded. Administrators must manage credentials via:
1. **The `.env` file:** This file defines usernames, database names, and basic configuration variables.
2. **Secrets:** Passwords are securely mapped into the containers via Docker Secrets. The active secrets in this stack are `db_password`, `db_root_password`, `wp_user_password`, `wp_admin_password`, and `ftp_password`. Update these credentials by modifying the corresponding secret files on the host before launching the stack.

## Checking Service Health
To verify that the infrastructure is running smoothly:
1. Run `docker ps` to see all active containers and their uptime.
2. Open the **cAdvisor** dashboard on port `8080` to verify memory and CPU load.
3. Access the WordPress Admin Panel, navigate to **Settings > Redis**, and check for a green "Connected" and "Writeable" status.