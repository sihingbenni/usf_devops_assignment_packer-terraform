source "amazon-ebs" "amazon-linux" {
  ami_name      = "custom-amazon-linux-ami-${formatdate("YYYY-MM-DD-hhmmss", timestamp())}"
  instance_type = "t2.micro"
  region        = var.aws_region
  source_ami    = "ami-08b5b3a93ed654d19"
  ssh_username  = "ec2-user"
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  token         = var.aws_session_token
}

build {
  name = "custom-amazon-linux-build"
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo usermod -a -G docker ec2-user", # add ec2-user to docker group
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
    ]
  }

  provisioner "file" {
    source      = var.public_key_path
    destination = "/home/ec2-user/.ssh/authorized_keys"
  }

  provisioner "shell" {
    inline = [
      "chmod 600 /home/ec2-user/.ssh/authorized_keys",
      "chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys"
    ]
  }

  post-processor "manifest" {
    output = "manifest-amazon-linux.json"
  }
}
