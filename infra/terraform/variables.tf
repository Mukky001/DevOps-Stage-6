variable "region" {
  description = "The AWS region to deploy to (Stockholm)"
  default     = "eu-north-1"
}

variable "key_name" {
  description = "The name of the SSH Key Pair in AWS"
  type        = string
  # Crucial: This must match the name of the key you uploaded to ~/.ssh/
  default     = "DevopsKey" 
}

variable "instance_type" {
  description = "The size of the server"
  type        = string
  # We use t3.medium (2 vCPU, 4GB RAM) because Java/Node apps are heavy
  default     = "t3.micro"
}
