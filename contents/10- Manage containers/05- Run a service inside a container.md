## 05- Run a service inside a container:

In the RHCSA exam, the topic **"Run a service inside a container"** involves creating and managing a service (such as an HTTP server or database server) within a container using **Podman**. You need to know how to run services in containers, ensure the service persists across reboots, and interact with that service from the host system.

### **What You Need to Know at the RHCSA Level**:

- How to pull container images and run containers.
- How to run a service inside a container (e.g., an HTTP server or SSH).
- How to ensure that the containerized service starts automatically upon reboot.
- Basic networking and exposing ports from containers to the host machine.

### **Steps to Running a Service Inside a Container (Podman)**:

1. **Pull the Container Image**:
   First, you must pull a container image that contains the desired service. For example, to run an HTTP server, you can pull an image like `httpd` (Apache web server).

   ```bash
   podman pull httpd
   ```

2. **Run the Service Inside a Container**:
   You need to run the container, expose the necessary ports, and ensure that the container starts the service. The `-d` flag runs the container in detached mode (background), and `-p` exposes the service port to the host.

   Example for an Apache HTTP server:

   ```bash
   podman run -d --name my_httpd -p 8080:80 httpd
   ```

   - `-d`: Runs the container in detached mode (background).
   - `--name my_httpd`: Assigns the container a name (for easier management).
   - `-p 8080:80`: Maps port 8080 on the host to port 80 in the container.

3. **Ensure the Service Starts on Reboot**:
   To ensure the container and its service automatically restart after a reboot, you can use the `--restart=always` option:

   ```bash
   podman run -d --name my_httpd --restart=always -p 8080:80 httpd
   ```

   This makes sure that the container restarts automatically if the system reboots.

4. **Verify the Service Is Running**:
   You can verify the container and its service are running using the following commands:

   - Check running containers:
     ```bash
     podman ps
     ```

   - Test if the service is working by accessing `http://localhost:8080` from your browser or using `curl`:

     ```bash
     curl http://localhost:8080
     ```

5. **Stopping and Starting the Container**:
   - To stop the container:
     ```bash
     podman stop my_httpd
     ```

   - To start the container:
     ```bash
     podman start my_httpd
     ```

### **RHCSA Exam-Like Questions**:

#### **Task 1: Run an HTTP Service in a Container**

- **Scenario**: 
  You need to pull the **httpd** container image, run it in the background, expose it on port 8080 of the host, and ensure the service starts automatically after a system reboot.

- **Solution**:
  ```bash
  podman pull httpd
  podman run -d --name webserver --restart=always -p 8080:80 httpd
  ```

  - The `--restart=always` flag ensures the container starts automatically after a reboot.
  - The container runs Apache HTTPD, which can be accessed via `http://localhost:8080` on the host.

#### **Task 2: Run an SSH Service in a Container**

- **Scenario**: 
  You are required to run an SSH server inside a container and expose it on port 2222 of the host.

- **Solution**:
  1. Pull an image with SSH service, e.g., `fedora`:
     ```bash
     podman pull fedora
     ```

  2. Run the SSH service inside the container:
     ```bash
     podman run -d --name my_ssh_container -p 2222:22 fedora /usr/sbin/sshd -D
     ```

     - `-p 2222:22`: Exposes port 22 inside the container as port 2222 on the host.
     - `/usr/sbin/sshd -D`: Runs the SSH daemon in the foreground.

#### **Task 3: Ensure Container Service Persists Across Reboots**

- **Scenario**: 
  You have set up a container running an HTTPD server. Now you need to ensure that the service restarts automatically on system reboots.

- **Solution**:
  ```bash
  podman run -d --name webserver --restart=always -p 8080:80 httpd
  ```

- After this configuration, if the system is rebooted, the container will automatically start again, and the HTTPD service will be available on `http://localhost:8080`.

### **Persistent Configuration (Systemd Integration)**:

Alternatively, for more control over service persistence, you can create a **systemd unit file** for managing the container. This ensures the container starts automatically during boot:

1. **Create a Systemd Service for the Container**:

   Create a systemd unit file at `/etc/systemd/system/my_httpd.service`:

   ```ini
   [Unit]
   Description=My HTTPD Container Service
   After=network.target

   [Service]
   ExecStart=/usr/bin/podman start -a webserver
   ExecStop=/usr/bin/podman stop -t 10 webserver
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```

2. **Enable the Systemd Service**:

   To make the container start automatically on boot:

   ```bash
   systemctl enable my_httpd.service
   ```

3. **Start the Service Manually (if required)**:

   ```bash
   systemctl start my_httpd.service
   ```

This approach ensures the container starts at boot and integrates with systemd's service management capabilities.

---

### **Summary**:

In the RHCSA exam, running a service inside a container using **Podman** requires you to:
- Pull the container image (such as HTTPD or SSH).
- Run the container with the necessary service, exposing the appropriate ports.
- Ensure that the container and the service persist across reboots using `--restart=always` or a systemd service.

