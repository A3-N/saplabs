# SAP Lab Environment - openSUSE Leap 15.4
FROM opensuse/leap:15.4

# Set root password
RUN echo 'root:P@ssw0rd!' | chpasswd

# Install required packages
RUN zypper refresh && \
    zypper install -y \
    openssh-server \
    firewalld \
    unrar \
    tcsh \
    libaio \
    libaio1 \
    uuidd \
    gcc \
    make \
    perl \
    java-1_8_0-openjdk \
    java-1_8_0-openjdk-devel \
    hostname \
    systemd \
    && zypper clean --all

# Configure SSH
RUN systemctl enable sshd && \
    mkdir -p /var/run/sshd

# Configure firewall for SSH
RUN systemctl enable firewalld

# Set hostname
RUN hostnamectl set-hostname vhcalnplci

# Create SAP setup directory
RUN mkdir -p /sapsetup

# Copy SAP installation files (these should be in the build context)
# Uncomment and adjust paths as needed when files are available
# COPY TD752SP04part01.rar /sapsetup/
# COPY TD752SP04part02.rar /sapsetup/
# COPY TD752SP04part03.rar /sapsetup/
# COPY TD752SP04part04.rar /sapsetup/
# COPY TD752SP04part05.rar /sapsetup/
# COPY TD752SP04part06.rar /sapsetup/
# COPY TD752SP04part07.rar /sapsetup/
# COPY TD752SP04part08.rar /sapsetup/
# COPY TD752SP04part09.rar /sapsetup/
# COPY TD752SP04part10.rar /sapsetup/
# COPY TD752SP04part11.rar /sapsetup/
# COPY SYBASE_ASE_TestDrive_2027_Mar_31.rar /sapsetup/

# Create entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose SSH port
EXPOSE 22

# Use systemd as init system
CMD ["/entrypoint.sh"]
