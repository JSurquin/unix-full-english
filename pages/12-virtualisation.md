---
layout: intro
routeAlias: 'virtualisation'
---

# Virtualization and containers 🖥️

### Virtualization and containerization concepts

<div class="pt-12">
  <span @click="next" class="px-2 p-3 rounded cursor-pointer hover:bg-white hover:bg-opacity-10 neon-border">
    Let's explore virtualization <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Core concepts 🔧

### What is virtualization?

**Definition:**
- Technique for running multiple operating systems
- On a single physical machine
- Full isolation between environments
- Better resource utilization

**Types of virtualization:**
- **Type 1 virtualization** : Native (bare metal) hypervisor
- **Type 2 virtualization** : Hosted hypervisor
- **Paravirtualization** : Special optimizations
- **Containerization** : Lightweight isolation

**Benefits:**
- Resource optimization
- Isolation and security
- Flexible deployment
- Easier backup and migration

---
layout: default
---

# Virtualization vs containerization 🔄

### Comparing approaches

**Traditional virtualization:**
```bash
# Physical machine
├── Hypervisor (VMware, KVM, Hyper-V)
    ├── VM 1 (full OS + applications)
    ├── VM 2 (full OS + applications)
    └── VM 3 (full OS + applications)
```

**Containerization:**
```bash
# Physical machine
├── Host OS (Linux)
    ├── Container 1 (applications + runtime)
    ├── Container 2 (applications + runtime)
    └── Container 3 (applications + runtime)
```

**Key differences:**
- **Resources** : VMs heavier, containers lighter
- **Startup** : VMs slower, containers faster
- **Isolation** : VMs full, containers partial
- **Portability** : Containers more portable

---
layout: default
---

# KVM (Kernel-based Virtual Machine) 🐧

### Native Linux virtualization

**Installing KVM:**
```bash
# Check hardware virtualization
egrep -c '(vmx|svm)' /proc/cpuinfo

# Installation on Ubuntu
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Add user to libvirt group
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```

**Management with virsh:**
```bash
# List VMs
virsh list --all

# Start a VM
virsh start vm_name

# Stop a VM
virsh shutdown vm_name

# View information
virsh dominfo vm_name
```

**Management with virt-manager:**
```bash
# Graphical interface
sudo apt install virt-manager
virt-manager
```

---
layout: default
---

# QEMU (Quick EMUlator) 🚀

### Emulator and virtualizer

**Installing QEMU:**
```bash
# Full installation
sudo apt install qemu-system qemu-utils

# Create a virtual disk
qemu-img create -f qcow2 vm.qcow2 10G

# Start a VM
qemu-system-x86_64 -hda vm.qcow2 -m 2048 -enable-kvm
```

**Startup options:**
```bash
# VM with graphical interface
qemu-system-x86_64 -hda vm.qcow2 -m 2048 -enable-kvm

# VM in console mode
qemu-system-x86_64 -hda vm.qcow2 -m 2048 -enable-kvm -nographic

# VM with networking
qemu-system-x86_64 -hda vm.qcow2 -m 2048 -enable-kvm -net nic -net user
```

**Image management:**
```bash
# Convert an image
qemu-img convert -f raw -O qcow2 image.raw image.qcow2

# Resize an image
qemu-img resize vm.qcow2 +5G

# View information
qemu-img info vm.qcow2
```

---
layout: default
---

# LXC (Linux Containers) 📦

### Native Linux containers

**Installing LXC:**
```bash
# Installation
sudo apt install lxc lxc-templates

# Verify installation
lxc-checkconfig

# List containers
lxc-ls
```

**Creating containers:**
```bash
# Create an Ubuntu container
sudo lxc-create -n my_container -t ubuntu

# Start the container
sudo lxc-start -n my_container

# Attach to the container
sudo lxc-attach -n my_container

# Stop the container
sudo lxc-stop -n my_container
```

**Advanced management:**
```bash
# View information
sudo lxc-info -n my_container

# Clone a container
sudo lxc-clone my_container my_container_clone

# Destroy a container
sudo lxc-destroy -n my_container
```

---
layout: default
---

# Docker introduction 🐳

### Modern containerization

**Installing Docker:**
```bash
# Official installation
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Verify installation
docker --version
docker run hello-world
```

**Basic commands:**
```bash
# List images
docker images

# Pull an image
docker pull ubuntu:20.04

# Run a container
docker run -it ubuntu:20.04 bash

# List containers
docker ps -a

# Remove a container
docker rm container_name
```

---
layout: default
---

# Docker images and containers 📦

### Image management

**Creating images:**
```dockerfile
# Simple Dockerfile
FROM ubuntu:20.04
RUN apt update && apt install -y nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Building images:**
```bash
# Build an image
docker build -t my_image .

# Tag an image
docker tag my_image my_image:v1.0

# Push to a registry
docker push my_image:v1.0
```

**Container management:**
```bash
# Start a container
docker start container_name

# Stop a container
docker stop container_name

# Restart a container
docker restart container_name

# View logs
docker logs container_name
```

---
layout: default
---

# Docker volumes and networks 💾

### Persistence and communication

**Docker volumes:**
```bash
# Create a volume
docker volume create my_volume

# Mount a volume
docker run -v my_volume:/data ubuntu:20.04

# Bind mount
docker run -v /host/path:/container/path ubuntu:20.04

# List volumes
docker volume ls
```

**Docker networks:**
```bash
# Create a network
docker network create my_network

# Run a container on a network
docker run --network my_network --name app1 nginx

# Connect an existing container
docker network connect my_network existing_container

# List networks
docker network ls
```

---
layout: default
---

# Docker Compose 🎼

### Container orchestration

**docker-compose.yml file:**
```yaml
version: '3.8'
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
    depends_on:
      - db
  
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: myapp
    volumes:
      - db_data:/var/lib/mysql

volumes:
  db_data:
```

**Compose commands:**
```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs

# Stop services
docker-compose down

# Rebuild images
docker-compose build
```

---
layout: default
---

# Monitoring and debugging 🔍

### Container observability

**Monitoring commands:**
```bash
# Real-time statistics
docker stats

# Detailed information
docker inspect container_name

# Processes in a container
docker top container_name

# Resource usage
docker system df
```

**Debugging:**
```bash
# Run a command in a container
docker exec -it container_name bash

# Copy files
docker cp file.txt container_name:/path/

# Follow logs
docker logs -f container_name
```

**Cleanup:**
```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Full cleanup
docker system prune -a
```

---
layout: default
---

# Container security 🔒

### Security best practices

**Non-privileged execution:**
```bash
# Run as non-root user
docker run --user 1000:1000 ubuntu:20.04

# Limit capabilities
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx
```

**Network isolation:**
```bash
# Internal network only
docker run --network none ubuntu:20.04

# Custom network
docker run --network my_internal_net --name app nginx
```

**Security scanning:**
```bash
# Scan an image
docker scan image_name

# With Trivy
trivy image image_name

# Check vulnerabilities
docker scout cves image_name
```

---
layout: default
---

# Hands-on exercises 🎯

### Putting it into practice

**Exercise 1: VM with KVM**
```bash
# Create an Ubuntu VM
sudo virt-install \
  --name ubuntu-vm \
  --ram 2048 \
  --disk path=/var/lib/libvirt/images/ubuntu-vm.qcow2,size=10 \
  --vcpus 2 \
  --os-type linux \
  --os-variant ubuntu20.04 \
  --network bridge=virbr0 \
  --graphics vnc,listen=0.0.0.0 \
  --noautoconsole \
  --location http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/
```

**Exercise 2: Docker container**
```bash
# Create a simple web container
docker run -d \
  --name my_web \
  -p 8080:80 \
  -v $(pwd)/html:/usr/share/nginx/html \
  nginx:alpine

# Verify access
curl http://localhost:8080
```

---
layout: default
---

# Best practices 💡

### Virtualization tips

**Performance:**
- Allocate appropriate resources
- Use paravirtualized drivers
- Optimize storage (SSD recommended)
- Monitor resource usage

**Security:**
- Keep VMs updated
- Use isolated networks
- Limit privileged access
- Scan for vulnerabilities regularly

**Maintenance:**
- Back up regularly
- Document configurations
- Clean up unused resources
- Monitor logs

---
layout: default
---

# Next steps 🎯

### What comes next

1. **Docker** in depth
2. **Capstone project**
3. **Quiz** for validation
4. **Debrief** and outlook

**Preparation:**
- Get comfortable with Docker
- Practice creating containers
- Try basic commands
- Explore virtualization concepts
