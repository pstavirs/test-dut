# Use the official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

# Set environment variables to avoid prompts during apt installation
ENV DEBIAN_FRONTEND=noninteractive

# Update apt and install required packages: OpenSSH server and iproute2
RUN apt-get update && \
    apt-get install -y sudo openssh-server iproute2 iputils-ping vim-tiny && \
    rm -rf /var/lib/apt/lists/*

# Create the necessary directory for SSH
RUN mkdir /var/run/sshd

# Create tc user, set password for tc, and also set root password to 'root'
RUN useradd -m -s /bin/bash tc && \
    echo 'tc:tc' | chpasswd && \
    echo 'root:root' | chpasswd

RUN echo 'tc ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/tc && \
    chmod 440 /etc/sudoers.d/tc

# Expose SSH port
EXPOSE 22

# Start the SSH service and keep the container running
CMD ["/usr/sbin/sshd", "-D"]

