## 02- Inspect container images:

In the RHCSA exam topic **"Inspect container images"**, you are expected to use **Podman** to inspect various details about container images, such as their metadata, configuration, and layers. This is important for understanding what the container image consists of, which can be helpful in troubleshooting or customizing the image.

### **What You Need to Know**:

1. **Inspect Container Images**:
   The primary command used for inspecting container images in **Podman** is `podman inspect`. This command provides detailed information about the image's configuration, including environment variables, entry points, exposed ports, and more.

   Example of inspecting a container image:
   ```bash
   podman inspect <image_name_or_ID>
   ```
   This returns a JSON output with details about the image, such as:
   - Image ID
   - Creation time
   - Labels
   - Command to be executed
   - Environment variables
   - Volumes, ports, and more

2. **Useful Options**:
   You can narrow down the information by using options like `--format` to extract specific data from the JSON output.

   Example to extract only the image creation time:
   ```bash
   podman inspect --format "{{ .Created }}" <image_name_or_ID>
   ```

3. **Image Layers**:
   You can also use the `podman history` command to display the layers of a container image, which shows how the image was built layer by layer.

   Example:
   ```bash
   podman history <image_name_or_ID>
   ```

### **Examples**:

1. **Basic Inspection of a Container Image**:
   - **Task**: Inspect the **nginx** image to view all metadata.
   - **Solution**:
     ```bash
     podman pull nginx
     podman inspect nginx
     ```

   This will show you detailed information, such as:
   ```json
   {
     "Id": "sha256:7b32c",
     "Created": "2024-01-01T12:34:56Z",
     "ContainerConfig": {
       "Cmd": [
         "nginx",
         "-g",
         "daemon off;"
       ],
       "ExposedPorts": {
         "80/tcp": {}
       }
     },
     "Config": {
       "Env": [
         "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
       ]
     }
   }
   ```

2. **Extract Specific Information**:
   - **Task**: Extract only the exposed ports from the **nginx** image.
   - **Solution**:
     ```bash
     podman inspect --format "{{ .Config.ExposedPorts }}" nginx
     ```

   This outputs:
   ```
   map[80/tcp:{}]
   ```

3. **Inspect the History of an Image**:
   - **Task**: Check the layers and how the **nginx** image was built.
   - **Solution**:
     ```bash
     podman history nginx
     ```

   This shows a list of image layers and the commands used to create each layer:
   ```
   ID            CREATED       CREATED BY                                      SIZE
   d6dfe4c60a10  2 weeks ago   /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon...  0B
   b0a8bba744a4  2 weeks ago   /bin/sh -c #(nop)  EXPOSE 80/tcp                0B
   ...
   ```

4. **Inspect a Specific Layer of the Image**:
   - **Task**: Inspect a particular layer to check what command was run.
   - **Solution**:
     ```bash
     podman inspect sha256:b0a8bba744a4
     ```

5. **Check Volumes in an Image**:
   - **Task**: Check if the image has volumes defined.
   - **Solution**:
     ```bash
     podman inspect --format "{{ .Config.Volumes }}" nginx
     ```

   If there are no volumes defined, the output would be:
   ```
   <nil>
   ```

### **RHCSA Exam-Like Question**:

- **Task**: Inspect the **ubi9** image to check the environment variables set in the image.
- **Solution**:
   ```bash
   podman pull registry.access.redhat.com/ubi9/ubi
   podman inspect --format "{{ .Config.Env }}" registry.access.redhat.com/ubi9/ubi
   ```

   Expected output:
   ```
   [PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin]
   ```

- **Task**: Check the creation time of the **httpd** container image.
- **Solution**:
   ```bash
   podman pull httpd
   podman inspect --format "{{ .Created }}" httpd
   ```

   Expected output:
   ```
   2024-01-10T11:23:45Z
   ```
