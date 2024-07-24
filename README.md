# 🌐︎ OpenRoaming Hybrid Machines

Welcome to the Openroaming Hybrid Machines! This repository offers a **reference implementation to establish an industry baseline** for the necessary components to develop FreeRadius and RadSecProxy machines capable of authenticating Passpoint profiles for Openroaming.

## Why it was created?

The project was developed to simplify the setup process for FreeRadius, RadSecProxy, and MySQL configurations in Openroaming. It also aims to ensure that all necessary components are in place to support the generation and synchronization of Passpoint provisioning profiles.

## How it works?

OpenRoaming is an **open standard developed to enable global, secure, and automatic Wi-Fi connectivity**. With OpenRoaming, users can connect to Wi-Fi networks without being prompted for login credentials, while carrying a unique embedded identity.

The script (prepare-debian11.sh) provided in this project simplifies the setup of FreeRadius, RadSecProxy, and MySQL servers by automating the process of preparing the necessary certificates, realm names, IP addresses, and other required information.

The script prompts the user for input and saves the values to a .env file, which is then used to configure the Docker containers for FreeRadius, RadSecProxy, and MySQL. This makes it easy for users to set up a secure and
automatic Wi-Fi connectivity environment using the OpenRoaming standard.

For more information about OpenRoaming Technology please visit: https://openroaming.org

## Prerequisites:
- Linux based system - Ubuntu 22.04 LTS (tested for the reference implementation)
- Knowledge about Linux OS (required to setup the project)
- Docker (required for running the application)
- Docker compose (responsible for managing multiple containers)
- Git (optional, if the user prefers to clone the repository)

### How to get the Project

There are two options to retrieve the project:

1. **Download Release Package**: Download the release package from the releases section on GitHub. This package contains
   only the required components to run,
   including `.env.sample`, `docker-compose.yml`, and other necessary files.


2. **Clone the Repository**: If the user is familiar with Git and want to access the complete source code, can clone the
   repository using the following command:

```bash
- git clone <repository-url>
```

# ⚙️ Installation Guide

Follow this link for more information on installing this project: [Installation Guide](INSTALATION.md).

