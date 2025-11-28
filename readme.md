🚀 DevOps Stage 6: Microservices Containerisation & Deployment
This repository contains the source code and infrastructure automation for deploying a polyglot microservices TODO application. The system is fully containerised using Docker, orchestrated via Docker Compose, provisioned on AWS using Terraform, and configured using Ansible.

🏗 Architecture
The application consists of 5 microservices behind a Traefik Reverse Proxy:

Traefik: Edge router, Load Balancer, and automatic SSL termination (Let's Encrypt).

Frontend: Vue.js application serving the UI.

Auth API: Go-based authentication service.

Todos API: Node.js service for managing todo items.

Users API: Java Spring Boot service for user management.

Log Processor: Python service (legacy compatible) for processing logs.

Redis: Message queue for inter-service communication.

Infrastructure Stack:

Cloud: AWS (EC2)

IaC: Terraform (State managed in S3)

Configuration: Ansible

Container Runtime: Docker & Docker Compose V2

🛠️ Prerequisites
Before you begin, ensure you have the following installed locally:

Terraform (v1.0+)

Ansible (v2.9+)

AWS CLI (Configured with aws configure)

Git

You also need:

A valid Domain Name (e.g., example.com).

An AWS Account with permissions to create EC2 instances and S3 buckets.

📂 Repository Structure
Bash

.
├── auth-api/             # Go Service
├── frontend/             # Vue.js Service
├── log-message-processor/# Python Service
├── todos-api/            # Node.js Service
├── users-api/            # Java Service
├── infra/
│   ├── ansible/
│   │   ├── roles/        # Configuration roles (dependencies, deploy)
│   │   └── playbook.yml  # Main Ansible entry point
│   └── terraform/
│       ├── main.tf       # Infrastructure definition
│       ├── variables.tf  # Configurable settings (Region, Instance Type)
│       └── backend.tf    # Remote State configuration
├── docker-compose.yml    # Container orchestration
└── .env.example          # Template for environment variables
⚙️ Configuration
1. Environment Variables
Copy the template to a real environment file:

Bash

cp .env.example .env
Open .env and update the following critical values:

Ini, TOML

# Domain Configuration
DOMAIN_NAME=your-domain.com  # <--- YOUR ACTUAL DOMAIN
ACME_EMAIL=your-email@example.com

# Security
JWT_SECRET=generated_random_secure_string
2. Terraform Backend
Navigate to infra/terraform/backend.tf and update the S3 bucket name to one you have created in your AWS account:

Terraform

bucket = "your-unique-state-bucket-name"
🚀 Deployment Guide
Step 1: Provision Infrastructure
We use Terraform to launch the server. This process creates a security group allowing HTTP/HTTPS/SSH, provisions a t3.micro instance, and automatically triggers Ansible.

Bash

cd infra/terraform
terraform init
terraform apply -auto-approve
What happens automatically:

Server is created with 20GB storage.

Terraform generates an inventory file for Ansible.

Ansible installs Docker, Git, and sets up Swap memory (to handle Java builds).

Ansible clones this repo to the server and starts the containers.

Step 2: Update DNS
Once Terraform finishes, it will output the Server Public IP.

Copy the IP address.

Go to your DNS Provider.

Update your A Record (@ or subdomain) to point to this new IP.

Step 3: Access the Application
Wait 1-2 minutes for DNS propagation and SSL certificate generation. Visit: https://your-domain.com

🔧 Manual Operations (Debugging)
If the automatic deployment fails (e.g., due to SSH timeouts), you can re-run the configuration layer without destroying the server:

Bash

# From infra/terraform/ directory
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory ../ansible/playbook.yml
Accessing the Server
To debug containers or view logs:

Bash

ssh -i ~/.ssh/DevopsKey.pem ubuntu@<SERVER_IP>
Bash

# View running services
sudo docker ps

# View logs
sudo docker logs traefik
sudo docker logs todo-app-users-api-1
🐛 Known Issues & Fixes
Java OOM (Out of Memory): The Java build is heavy. The Ansible script automatically creates a 2GB Swap file to prevent the server from freezing on t3.micro instances.

Python Build Failure: The log-message-processor uses a legacy library (thriftpy). The Dockerfile is pinned to python:3.6-slim-buster to ensure compatibility with older C-extensions.

404 Not Found: If the page loads 404, ensure your DOMAIN_NAME in .env matches your actual URL exactly. Traefik routes based on the Host header.

🤝 Credits
Project completed as part of the DevOps Internship Stage 6.
