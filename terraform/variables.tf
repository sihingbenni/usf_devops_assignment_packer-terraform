variable "aws_access_key" {
  type        = string
  sensitive   = true
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS Secret Key"
}

variable "aws_session_token" {
  type        = string
  sensitive   = true
  description = "AWS Session Token"
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region"
}


variable "your_ip_address" {
  type        = string
  description = "Your IP Address"
}

variable "linux_ami_id" {
  type        = string
  description = "ID of the Linux AMI created by Packer"
}

variable "ubuntu_ami_id" {
  type        = string
  description = "ID of the Ubuntu AMI created by Packer"
}

variable "public_key_path" {
    type        = string
    description = "Path to your public key"
}

variable "private_key_path" {
    type        = string
    description = "Path to your private key"
}
