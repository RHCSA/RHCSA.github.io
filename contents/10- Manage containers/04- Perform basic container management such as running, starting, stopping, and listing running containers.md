## 04- Perform basic container management such as running, starting, stopping, and listing running containers:

In the RHCSA exam, the topic **"Perform basic container management such as running, starting, stopping, and listing running containers"** revolves around using **Podman** to manage containers. Podman is a daemonless, rootless container engine, which is compatible with many Docker CLI commands but does not rely on a central daemon to operate.


### **Key Concepts for RHCSA Level**:

1. **Podman**:
   - Manage containers locally without requiring root privileges.
   - Compatible with Docker but more lightweight (no daemon process).

### **Basic Commands for Container Management**:

1. **Pulling a Container Image**:
   Before you can run a container, you need to pull the image from a container registry.

   ```bash
   podman pull <image_name>
   ```

   Example:
   ```bash
   podman pull registry.access.redhat.com/ubi9/ubi
   ```
   This pulls the **Universal Base Image (UBI)** from the Red Hat registry.

2. **Running a Container**:
   You can start a container from an image using the `podman run` command.

   ```bash
   podman run <options> <image_name> <command>
   ```

   Example:
   ```bash
   podman run -d --name webserver -p 8080:80 httpd
   ```
   - `-d` runs the container in detached mode (in the background).
   - `--name webserver` gives the container a custom name ("webserver").
   - `-p 8080:80` maps port 8080 on the host to port 80 in the container.

3. **Listing Running Containers**:
   You can view all active (running) containers with the following command:

   ```bash
   podman ps
   ```

4. **Listing All Containers (including stopped ones)**:
   To view all containers (including stopped ones):

   ```bash
   podman ps -a
   ```

5. **Stopping a Running Container**:
   To stop a container that is running:

   ```bash
   podman stop <container_name_or_ID>
   ```

   Example:
   ```bash
   podman stop webserver
   ```

6. **Starting a Stopped Container**:
   To restart a stopped container:

   ```bash
   podman start <container_name_or_ID>
   ```

   Example:
   ```bash
   podman start webserver
   ```

7. **Removing a Container**:
   To remove a container (stopped or running):

   ```bash
   podman rm <container_name_or_ID>
   ```

   Example:
   ```bash
   podman rm webserver
   ```

---

### **RHCSA Exam-Like Questions**:

#### **Task 1: Pull and Run a Container**

- **Scenario**: 
  You are required to pull the **nginx** image from Docker Hub, run it in the background, and make sure the container is automatically restarted if the system reboots.
  
- **Solution**:
  ```bash
  podman pull nginx
  podman run -d --name my_nginx --restart=always -p 8080:80 nginx
  ```
  - The `--restart=always` option ensures the container will automatically start on reboot.
  - The `-d` flag runs the container in detached mode (background).
  - The container is mapped to port 8080 on the host and port 80 in the container.

#### **Task 2: List All Containers**

- **Scenario**:
  You are asked to list all running containers, followed by a list of all containers (running and stopped).

- **Solution**:
  ```bash
  podman ps
  podman ps -a
  ```

#### **Task 3: Stop and Remove a Running Container**

- **Scenario**:
  You need to stop a running container named **my_nginx** and then remove it.

- **Solution**:
  ```bash
  podman stop my_nginx
  podman rm my_nginx
  ```

#### **Task 4: Start a Stopped Container**

- **Scenario**:
  Start a container named **my_nginx** that was previously stopped.

- **Solution**:
  ```bash
  podman start my_nginx
  ```

#### **Task 5: Ensure a Container Starts on Boot**

- **Scenario**:
  You are required to make sure that a container named **my_nginx** restarts automatically if the system reboots.

- **Solution**:
  ```bash
  podman run -d --name my_nginx --restart=always -p 8080:80 nginx
  ```

---

### **Ensuring Persistence in RHCSA**:

In the RHCSA exam, it’s important to ensure that any changes you make are persistent across reboots. For container management, this can be achieved by using the `--restart=always` option when running the container:

```bash
podman run -d --name <container_name> --restart=always <image_name>
```

This will make sure the container is restarted if the system reboots. Alternatively, you can create a **systemd service file** to manage the container, ensuring even more control over how and when the container is started during boot.

