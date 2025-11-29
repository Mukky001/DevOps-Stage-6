
-----

## 📄 `README.md` 

````markdown
# DevOps Stage 6: Fully Automated Microservices Deployment (Polyglot Stack) 🚀

This repository contains the complete solution for deploying a microservices-based **Todo Application** using Infrastructure as Code (IaC) principles. The goal was to eliminate manual steps, ensure environment consistency, and secure all endpoints with HTTPS.

## 🌟 Introduction

This project solves the complex challenge of taking disparate application components—written in **Java, Go, Node.js, and Python**—and deploying them reliably and securely onto a production-ready AWS environment using a single, automated command.

The success of this deployment rests on the seamless integration of Docker, Ansible, Terraform, and Traefik, proving proficiency in modern CI/CD practices and multi-language application management.

---

## 🛠️ The Technology Stack (The "How It Works")

The solution is built upon a layered stack of industry-standard DevOps tools:

| Tool | Purpose in this Project | The "Big Picture" Role |
| :--- | :--- | :--- |
| **Docker / Docker Compose** | **Containerisation** | Isolates each microservice (Java/Go/Python) with its specific environment and dependencies, solving the "works on my machine" problem. |
| **Terraform (IaC)** | **Infrastructure Provisioning** | Manages the AWS EC2 server and Security Groups as code. **Enables single-command deployment** by triggering Ansible automatically. |
| **Ansible** | **Configuration Management** | Ensures the server is production-ready by installing Docker, Git, and creating essential **Swap Memory** to prevent memory crashes on small VMs. |
| **Traefik** | **API Gateway / Edge Routing** | Routes all public traffic (HTTPS/Port 443) to the correct internal container and **automates the SSL certificate generation** (Let's Encrypt). |
| **AWS EC2** | **Compute** | Provides the underlying virtual server hosting the Docker containers. |

---

## 🗺️ Architecture and Data Flow

The application features a secure, layered architecture where **Traefik acts as the single point of entry** for all public requests.

1.  **Incoming Request (HTTPS):** The user connects to the public domain (`freewebuniverse.chickenkiller.com`) via HTTPS.
2.  **Traefik Routing:** Traefik receives the request and examines the URL Path:
    * Requests to `/` are sent to the **Frontend** (Vue.js).
    * Requests to `/api/auth/login` are matched by the Traefik router, which uses the **StripPrefix Middleware** to remove the `/api/auth` prefix before forwarding the request to the Go Auth API container. This ensures the Go code receives the clean `/login` path it expects.
3.  **Service Interaction:** The APIs communicate internally via the Redis queue for processing logs and asynchronous tasks.
4.  **Java Compatibility Fix:** The **Users API** (Java) runs successfully only because its Docker container is pinned to a specific compatible runtime (JDK 8), overcoming fundamental application stability issues.

---

## ⚙️ Quick Start Guide (Replication)

This guide shows how to replicate the entire automated deployment on your own AWS account using a **single Terraform command**.

### 1. Prerequisites Checklist

* [ ] AWS Access Key ID and Secret Access Key configured via `aws configure`.
* [ ] SSH Key Pair created in AWS (e.g., `DevopsKey`).
* [ ] A dedicated S3 Bucket created for Terraform state (e.g., `my-project-state-bucket`).
* [ ] Terraform and Ansible installed on your local control machine.

### 2. Configure Local Files

a. **Create `.env`:** Copy the template and fill in your details. **DO NOT PUSH THIS FILE TO GIT.**

```bash
cp .env.example .env
````

**(Note: Ensure DOMAIN\_NAME has NO http/https prefix.)**

b. **Update Terraform Backend:** Navigate to `infra/terraform/backend.tf` and replace the placeholder bucket name with your actual S3 bucket name.

### 3\. Deploy the Infrastructure (The Single Command)

Run these commands from the `infra/terraform/` directory:

```bash
# 1. Initialize Terraform (Connects to S3 Backend)
terraform init

# 2. Launch Server, Configure, and Deploy Application (The Automation Chain)
# This creates EC2, installs Docker, and runs Ansible deploy role.
terraform apply -auto-approve
```

### 4\. Verification

1.  **Update DNS:** Copy the **`server_public_ip`** output from Terraform and update the A-Record for your domain.
2.  **Check Site:** Visit `https://your-domain.com`.
3.  **Login Test:** Use the default credentials (e.g., `admin`/`Admin123`) to verify Auth API functionality.

-----

## 🔒 Security & Idempotency

  * **Security:** All HTTP traffic is redirected to HTTPS (Port 443) via Traefik. The Ansible deploy task uses SSH keys (`~/.ssh/DevopsKey.pem`) and disables host key checking for non-interactive automation. Secrets are isolated in the `.env` file.
  * **Idempotency:** The deployment is fully idempotent. Rerunning the `terraform apply -auto-approve` command will check the current state against the desired state and **only execute commands if necessary**, preventing unnecessary rebuilds or server restarts.

<!-- end list -->

```

```
