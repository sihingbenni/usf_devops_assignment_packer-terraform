
variable "aws_access_key" {
  type        = string
  sensitive   = true
  description = "AWS Access Key"
  default     = "<CHANGE_ME>"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS Secret Key"
  default     = "<CHANGE_ME>"
}

variable "aws_session_token" {
  type        = string
  sensitive   = true
  description = "AWS Session Token"
  default     = "<CHANGE_ME>"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "public_key_path" {
  type        = string
  description = "Path to your public key"
  default     = "<CHANGE_ME>"
}
