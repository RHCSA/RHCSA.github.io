## 06- Configure a container to start automatically as a systemd service:

In the **RHCSA exam**, "Configuring a container to start automatically as a systemd service" is an important skill that requires knowledge of both **Podman** (for container management) and **systemd** (for service management in Linux).

### Steps to Configure a Container to Start Automatically as a systemd Service:

#### 1. **Create and Run a Container**
   First, ensure that you have a container running. For instance, let's start a simple container using Podman.

   ```bash
   podman run -d --name my-container -p 8080:80 httpd
   ```

   - `-d` makes the container run in the background (detached mode).
   - `--name my-container` gives the container a specific name.
   - `-p 8080:80` binds the host's port 8080 to the container's port 80 (assuming it’s a web server, like Apache `httpd`).

#### 2. **Generate the systemd Service Unit File**
   Podman has a built-in feature to generate a systemd unit file for the container.

   ```bash
   podman generate systemd --name my-container --files --new
   ```

   This command creates a `.service` file in your current directory. The `--new` option ensures that it creates a fresh service file with automatic start/stop capabilities.

   Example output:
   ```
   ./container-my-container.service
   ```

#### 3. **Move the systemd Unit File to the Correct Directory**
   Move the generated service file to the appropriate location, which is `/etc/systemd/system/`.

   ```bash
   sudo mv container-my-container.service /etc/systemd/system/
   ```

#### 4. **Reload systemd to Apply the Changes**
   Once you’ve moved the service file, reload the systemd daemon to recognize the new service unit.

   ```bash
   sudo systemctl daemon-reload
   ```

#### 5. **Enable the Service for Automatic Start**
   Now, enable the service so that it starts automatically on boot.

   ```bash
   sudo systemctl enable container-my-container
   ```

   This ensures that every time the system boots, the container will be started as a service.

#### 6. **Start the Service**
   You can start the service immediately using:

   ```bash
   sudo systemctl start container-my-container
   ```

#### 7. **Verify the Service Status**
   You can check if the service is running properly with:

   ```bash
   sudo systemctl status container-my-container
   ```

### What You Need to Know for the RHCSA Exam:

1. **Podman Commands**: Be comfortable with Podman commands like `podman run`, `podman ps`, and `podman generate systemd`.
   
2. **systemd Basics**: Understand how to manage services using systemd (`systemctl`), such as starting, stopping, enabling, disabling, and reloading services.

3. **Container Persistence**: Any container you configure to run as a systemd service should persist through system reboots.

### Practice Question (similar to RHCSA Exam):

**Task**:  
You are asked to run an NGINX container using Podman, configure it to start on boot as a systemd service, and ensure that it automatically starts on system reboot.

1. Run the NGINX container on port 8080.
2. Generate a systemd service for the container.
3. Enable and start the service.
4. Verify that the container starts on reboot.

**Expected Solution**:

1. **Run the container**:
   ```bash
   podman run -d --name my-nginx -p 8080:80 nginx
   ```

2. **Generate systemd service**:
   ```bash
   podman generate systemd --name my-nginx --files --new
   ```

3. **Move the service file**:
   ```bash
   sudo mv container-my-nginx.service /etc/systemd/system/
   ```

4. **Reload systemd**:
   ```bash
   sudo systemctl daemon-reload
   ```

5. **Enable and start the service**:
   ```bash
   sudo systemctl enable container-my-nginx
   sudo systemctl start container-my-nginx
   ```

6. **Check status**:
   ```bash
   sudo systemctl status container-my-nginx
   ```

