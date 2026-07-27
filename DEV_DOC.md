# Developer Documentation

This guide is intended for developers maintaining, debugging, or extending the Inception infrastructure.

## Setting Up the Environment
To build the project from scratch, the host machine must have Docker Engine and Docker Compose installed.

1. **Directories:** Ensure the host data directories exist for persistent storage. These are located at `/home/zzaoui/data/mariadb` and `/home/zzaoui/data/wordpress`.
2. **Configuration (`.env`):** Configure the `.env` file with necessary structural variables (`DOMAINE_NAME`, `DB_NAME`, `FTP_USER`, etc.).
3. **Secrets:** Ensure your password text files are correctly created and referenced in the `docker-compose.yml` to populate the `secrets` block (e.g., `db_password: file: ${DB_PASSWORD_FILE}`).

## Build and Launch Architecture
The project is orchestrated by Docker Compose using the `inception_network` bridge network. 
* Launch the deployment using the commands specified in the `Makefile` (e.g., `make all` or `make bonus`).
* All containers utilize the `restart: always` policy to ensure they automatically recover from unexpected crashes.

## Managing Containers and Volumes
Use the following Docker commands to interact with the stack:
* **View Real-Time Logs:** `docker compose logs -f`
* **Access a Container's Shell:** `docker exec -it <container_name> /bin/bash`
* **Monitor Container Resources:** `docker stats`
* **Flush All Docker Cache (Images, Networks):** `docker system prune -a`

## Data Storage and Persistence
Containers are ephemeral. To ensure data survives container restarts or rebuilds, this project relies on explicitly defined **Docker Volumes** utilizing host-bound drivers.

* **`db_data`:** Bound to the `mariadb` container at `/var/lib/mysql`. It is configured with the `local` driver, using `device: /home/zzaoui/data/mariadb` and `o: bind`.
* **`wp_data`:** Bound to `wordpress`, `nginx`, and `ftp` at `/var/www/wordpress`. It is configured with the `local` driver, using `device: /home/zzaoui/data/wordpress` and `o: bind`.