# 1. Dynamic AMI Lookup
# Automatically finds the latest Ubuntu 24.04 Image ID in your region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu Creator)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# 2. Security Group (The Firewall)
resource "aws_security_group" "web_sg" {
  name        = "todo-app-sg-stage6"
  description = "Allow Web and SSH traffic"

  # Allow SSH (Port 22) - Critical for Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP (Port 80) - For Traefik
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (Port 443) - For Traefik SSL
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow server to download updates/docker images
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. The Server (EC2 Instance)
resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # ⚠️ FIX: Increase storage to 20GB to prevent disk space errors
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "Stage-6-Prod-Server"
  }

  # 4. The "Handshake" (Terraform -> Ansible Integration)
  # This provisioner runs ON YOUR VM after the new server is created.
  provisioner "local-exec" {
    command = <<EOT
      # A. Generate the Ansible Inventory file dynamically
      echo "[app_servers]" > ../ansible/inventory
      echo "${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem" >> ../ansible/inventory
      
      # B. Wait for the new server to wake up (SSH readiness)
      sleep 30
      
      # C. Run Ansible automatically!
      # We disable host key checking to avoid the "Are you sure?" yes/no prompt.
      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory ../ansible/playbook.yml
    EOT
  }
}
