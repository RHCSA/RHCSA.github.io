## 03- Perform container management using commands such as podman and skopeo:

In the RHCSA exam topic **"Perform container management using commands such as Podman and Skopeo"**, you are expected to understand the fundamentals of managing containers, container images, and their lifecycle using **Podman** for local containers and **Skopeo** for container image handling across different registries. You need to be able to pull, run, manage, and transfer containers and images across registries while ensuring the persistence of changes.

### **Key Concepts for RHCSA Level**:

1. **Podman**: A tool used for managing containers. It is a rootless, daemon-less container engine that is compatible with Docker CLI commands but operates without a central daemon.
   
2. **Skopeo**: A tool used for inspecting and transferring container images between repositories without needing to have a running container daemon. It can also copy images between different registries.

---

### **Podman Container Management**:

1. **Pulling a Container Image**:
   To download a container image from a registry.
   ```bash
   podman pull <image_name>
   ```
   Example: Pull the **ubi9** image:
   ```bash
   podman pull registry.access.redhat.com/ubi9/ubi
   ```

2. **Running a Container**:
   To create and start a container from an image.
   ```bash
   podman run <options> <image_name> <command>
   ```
   Example: Run a container with **ubi9** and start a Bash shell.
   ```bash
   podman run -it registry.access.redhat.com/ubi9/ubi /bin/bash
   ```

3. **Listing Running and Stopped Containers**:
   - Running containers:
     ```bash
     podman ps
     ```
   - All containers (including stopped):
     ```bash
     podman ps -a
     ```

4. **Stopping and Starting Containers**:
   - Stop a running container:
     ```bash
     podman stop <container_name_or_ID>
     ```
   - Start a stopped container:
     ```bash
     podman start <container_name_or_ID>
     ```

5. **Inspecting a Running Container**:
   View detailed information about a container.
   ```bash
   podman inspect <container_name_or_ID>
   ```

6. **Committing Changes to a Container**:
   After making changes inside a running container, you can save those changes to a new image.
   ```bash
   podman commit <container_name_or_ID> <new_image_name>
   ```
   Example:
   ```bash
   podman commit my_container custom_image:v1
   ```

7. **Removing Containers and Images**:
   - Remove a container:
     ```bash
     podman rm <container_name_or_ID>
     ```
   - Remove an image:
     ```bash
     podman rmi <image_name_or_ID>
     ```

---

### **Skopeo Container Image Management**:

1. **Inspecting Remote Images Without Pulling**:
   Skopeo allows you to inspect an image from a remote registry without downloading it.
   ```bash
   skopeo inspect docker://<registry>/<image_name>
   ```
   Example: Inspect the **ubi9** image from Red Hat's registry.
   ```bash
   skopeo inspect docker://registry.access.redhat.com/ubi9/ubi
   ```

2. **Copying Container Images Between Registries**:
   You can copy images between registries, even across different protocols, without pulling them locally.
   ```bash
   skopeo copy docker://<source_registry>/<image_name> docker://<target_registry>/<image_name>
   ```
   Example: Copy **ubi9** from Red Hat's registry to your local registry.
   ```bash
   skopeo copy docker://registry.access.redhat.com/ubi9/ubi docker://localhost:5000/ubi9/ubi
   ```

3. **Deleting Remote Images**:
   To delete images from a registry:
   ```bash
   skopeo delete docker://<registry>/<image_name>
   ```

---

### **Examples of RHCSA Exam-Like Questions**:

#### **Task 1: Manage Containers with Podman**

- **Scenario**: 
  You are asked to pull the **httpd** container image from a public registry, run it in the background, and ensure the container starts automatically on system reboot.

- **Solution**:
  ```bash
  podman pull httpd
  podman run -d --name my_httpd --restart=always -p 8080:80 httpd
  ```

  - The `-d` option runs the container in the background.
  - The `--restart=always` option ensures the container starts automatically on reboot.
  - The `-p 8080:80` option maps port 8080 on the host to port 80 in the container.

#### **Task 2: Inspect a Container Image with Skopeo**

- **Scenario**: 
  Inspect the metadata of the **ubi9** image from Red Hat's container registry without pulling it to the local system.

- **Solution**:
  ```bash
  skopeo inspect docker://registry.access.redhat.com/ubi9/ubi
  ```

  This will output the image details, such as architecture, environment variables, and layers.

#### **Task 3: Copy a Container Image to a Local Registry**

- **Scenario**: 
  You need to copy the **nginx** image from Docker Hub to your local container registry running on port 5000.

- **Solution**:
  ```bash
  skopeo copy docker://docker.io/library/nginx docker://localhost:5000/nginx
  ```

  This copies the image from Docker Hub (`docker.io`) to your local registry at `localhost:5000`.

---

### **Key Commands and Persistence**:

In RHCSA, **persistence** is crucial, especially for container configurations. You can ensure containers persist across reboots using the `--restart` flag, or by creating systemd service units for containers. For example:

- **Ensure a Container Starts on Boot**:
  - Use the `--restart=always` flag when starting the container:
    ```bash
    podman run -d --name persistent_container --restart=always <image_name>
    ```

By using this flag, the container automatically starts again when the system reboots, ensuring persistence in the RHCSA exam environment.
