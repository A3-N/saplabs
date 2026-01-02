# SAP Lab Environment - Docker Setup

This Docker setup creates an SAP Lab environment using openSUSE Leap 15.4 with all necessary dependencies and configurations.

## Prerequisites

- Docker and Docker Compose installed
- SAP installation files (place in the project directory):
  - `TD752SP04part01.rar` through `TD752SP04part11.rar`
  - `SYBASE_ASE_TestDrive_2027_Mar_31.rar`

## Quick Start

### 1. Prepare SAP Installation Files

Place all required `.rar` files in the project directory:
```
sap-lab-module-abap/
├── TD752SP04part01.rar
├── TD752SP04part02.rar
├── ...
├── TD752SP04part11.rar
└── SYBASE_ASE_TestDrive_2027_Mar_31.rar
```

### 2. Uncomment COPY Commands in Dockerfile

Edit `Dockerfile` and uncomment the COPY commands for the SAP installation files (lines with `# COPY TD752SP04...`).

### 3. Build and Start the Container

```bash
# Build and start the container
docker-compose up -d --build

# View logs
docker-compose logs -f

# Check container status
docker-compose ps
```

### 4. Access the Container

```bash
# SSH access (from host)
ssh root@localhost -p 2222
# Password: P@ssw0rd!

# Or use docker exec
docker exec -it sap-lab-environment bash
```

### 5. Install SAP

Once inside the container:
```bash
cd /sapsetup
./install.sh
```

## Network Configuration

The setup creates a bridged Docker network named `sap-network`:
- **Network**: 172.20.0.0/16
- **Gateway**: 172.20.0.1
- **Container hostname**: vhcalnplci

## Container Details

- **OS**: openSUSE Leap 15.4
- **Root Password**: P@ssw0rd!
- **Hostname**: vhcalnplci
- **SSH Port**: 2222 (mapped from container port 22)

## Installed Packages

- OpenSSH Server
- Firewalld
- unrar
- tcsh
- libaio, libaio1
- uuidd
- gcc, make, perl
- Java 1.8.0 OpenJDK (JRE and JDK)

## Manual Setup Steps (if needed)

If you need to run the setup steps manually:

```bash
# Check SSH status
systemctl status sshd

# Check firewall status
systemctl status firewalld

# Verify Java installation
java -version
update-alternatives --config java

# Extract SAP files (if not auto-extracted)
cd /sapsetup
unrar x SYBASE_ASE_TestDrive_2027_Mar_31.rar
unrar x TD752SP04part01.rar
rm *.rar
chmod +x install.sh
```

## Stopping and Removing

```bash
# Stop the container
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Troubleshooting

### Container won't start
- Ensure you have sufficient disk space
- Check Docker logs: `docker-compose logs`
- Verify systemd is working: `docker exec -it sap-lab-environment systemctl status`

### SSH connection refused
- Check if SSH service is running: `docker exec -it sap-lab-environment systemctl status sshd`
- Verify port mapping: `docker-compose ps`

### Firewall issues
- Check firewall status: `docker exec -it sap-lab-environment systemctl status firewalld`
- Verify SSH rule: `docker exec -it sap-lab-environment firewall-cmd --list-services`

## Notes

- The container runs with `privileged: true` to support systemd
- SAP installation files are automatically extracted on first run if present
- The `/sapsetup` directory is persisted in a Docker volume
- The container uses systemd as its init system for proper service management
