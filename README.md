*This project has been created as part of the 42 curriculum by zzaoui.*

## Description

**Inception** is a system administration and infrastructure project that aims to broaden knowledge of containerization. The goal is to set up a small infrastructure utilizing Docker and Docker Compose under specific rules. 

Instead of deploying everything on a single host or VM, the project requires a microservices architecture. Each service runs in its own dedicated, lightweight container. The services in this stack include `nginx`, `mariadb`, `wordpress`, `redis`, `ftp`, `adminer`, `website`, and `cadvisor`. The project strictly relies on Docker Compose to orchestrate the build, deployment, and networking of these interconnected services.

### Main Design Choices & Docker Usage
* **Custom Dockerfiles:** No pre-configured images (like `nginx:latest` or `wordpress:fpm`) are used. Every service is built from a minimal Debian base.
* **Separation of Concerns:** Each container handles a single process (PID 1). 
* **Dependencies & Startup Order:** Services are orchestrated with specific boot orders; for example, `wordpress` waits for `mariadb` and `redis`, while `cadvisor` depends on `nginx`, `mariadb`, `wordpress`, and `website`.

### Infrastructure Comparisons

#### Virtual Machines vs Docker
Virtual Machines (VMs) employ a Hypervisor to emulate hardware, requiring a full guest Operating System for each instance. This results in heavy resource consumption and slow boot times. Docker, conversely, uses OS-level virtualization. Containers share the host system's kernel, making them lightweight, fast to start, and highly portable.

#### Secrets vs Environment Variables
Environment Variables are often passed in plaintext and can be exposed via process trees (e.g., `/proc`) or container inspection commands, posing a security risk for sensitive data. Docker Secrets act as a more secure alternative. This project explicitly utilizes Docker Secrets to pass sensitive files into the containers securely (e.g., `/run/secrets/db_password`, `/run/secrets/wp_admin_password`, and `/run/secrets/ftp_password`).

#### Docker Network vs Host Network
Using the Host Network removes network isolation, allowing the container to bind directly to the host's IP and ports. A Docker Network (like a user-defined bridge) creates an isolated subnet. Containers communicate with each other securely using internal DNS resolution on the custom `inception_network`, exposing only strictly necessary entry ports to the outside host machine.

#### Docker Volumes vs Bind Mounts
Bind Mounts rely on the host machine's specific directory structure, bypassing Docker's volume management. Standard Docker Volumes are managed entirely by the Docker daemon (`/var/lib/docker/volumes/`). To satisfy the project requirements while ensuring persistent data on the host, this project bridges the two concepts: it uses Docker named volumes (`db_data` and `wp_data`) but configures them using the `local` driver with bind options linking directly to the host directories (`/home/zzaoui/data/mariadb` and `/home/zzaoui/data/wordpress`).

---

## Instructions

### Compilation and Installation
Ensure Docker, Docker Compose, and `make` are installed on your system. 

1. Edit your local `/etc/hosts` file to resolve the domain name to your localhost:
```bash
   sudo nano /etc/hosts
   # Add the following line:
   127.0.0.1 zzaoui.42.fr
```

2. Clone the repository and navigate to the root directory.
3. Set up the required environment variables in your `.env` file and ensure the secret files referenced in the `docker-compose.yml` are properly created on the host.



### Execution

* **To launch the full stack:**
```bash
make all

```


* **To stop all services:**
```bash
make down

```



---

## Resources

* **Documentation:**
* [Docker Official Documentation](https://docs.docker.com/)
* [Nginx Web Server Admin Guide](https://docs.nginx.com/nginx/admin-guide/)
* [WP-CLI Documentation](https://developer.wordpress.org/cli/commands/)
* [MariaDB Server Documentation](https://www.google.com/search?q=https://mariadb.com/kb/en/mariadb-server-documentation/)


* **Use of Artificial Intelligence:**
AI tools were utilized during the development of this project for architectural review and debugging purposes, and the creation of documentation files.