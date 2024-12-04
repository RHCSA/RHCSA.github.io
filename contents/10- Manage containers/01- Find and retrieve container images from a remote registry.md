## 01- Find and retrieve container images from a remote registry:

The RHCSA exam topic **"Find and retrieve container images from a remote registry"** in the context of RHEL 9 refers to working with **Podman**, a tool used for managing containers and images, similar to Docker. RHEL 9 prefers using **Podman** instead of Docker for container-related tasks.

### **What You Need to Know:**

1. **Find Container Images**:
   Use the `podman search` command to look for container images on a remote registry. Red Hat uses the **Red Hat Container Catalog** or **Docker Hub** to host images.

   Example:
   ```bash
   podman search nginx
   ```
   This command searches for the **nginx** container image on the default remote registry.

2. **Retrieve (Pull) Container Images**:
   Use the `podman pull` command to download the container image from the remote registry to your local system.

   Example:
   ```bash
   podman pull registry.access.redhat.com/ubi9/ubi
   ```
   This pulls the **Universal Base Image (UBI)** for RHEL 9 from the Red Hat registry.

   If you're pulling an image from Docker Hub, you can use:
   ```bash
   podman pull docker.io/library/nginx
   ```

3. **List Retrieved Images**:
   After pulling an image, you can list it with the `podman images` command to verify it's downloaded.

   Example:
   ```bash
   podman images
   ```

4. **Run a Container from the Retrieved Image**:
   Once the image is retrieved, you can run a container from it using the `podman run` command.

   Example:
   ```bash
   podman run -d --name mynginx -p 80:80 nginx
   ```
   This command runs the nginx container in detached mode and maps port 80 on the host to port 80 in the container.

### **RHCSA Exam-Like Examples**:

1. **Find a specific image on a remote registry**:
   - **Task**: Search for the `httpd` image on Docker Hub.
   - **Solution**:
     ```bash
     podman search httpd
     ```

2. **Retrieve (pull) an image from a remote registry**:
   - **Task**: Pull the **RHEL 9 UBI** image from Red Hat's registry.
   - **Solution**:
     ```bash
     podman pull registry.access.redhat.com/ubi9/ubi
     ```

3. **Verify the pulled image**:
   - **Task**: List all images on the system.
   - **Solution**:
     ```bash
     podman images
     ```

4. **Pull an image from Docker Hub**:
   - **Task**: Retrieve the **nginx** container image from Docker Hub.
   - **Solution**:
     ```bash
     podman pull docker.io/library/nginx
     ```

5. **Run a container using a pulled image**:
   - **Task**: Run the `httpd` image as a container, mapping port 8080 on the host to port 80 in the container.
   - **Solution**:
     ```bash
     podman run -d --name myhttpd -p 8080:80 httpd
     ```

6. **View running containers**:
   - **Task**: List all running containers.
   - **Solution**:
     ```bash
     podman ps
     ```
