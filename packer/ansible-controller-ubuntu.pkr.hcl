source "amazon-ebs" "ansible-controller-ubuntu" {
  ami_name      = "ansible-controller-ami-${formatdate("YYYY-MM-DD-hhmmss", timestamp())}"
  instance_type = "t2.micro"
  region        = var.aws_region
  source_ami    = "ami-084568db4383264d4" # Ubuntu 24.04 LTS
  ssh_username  = "ubuntu"
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  token         = var.aws_session_token
}

build {
  name = "ansible-controller-build"
  sources = [
    "source.amazon-ebs.ansible-controller-ubuntu"
  ]

  # Add the public key, so that the Bastion Host can connect to the Ansible Controller
  provisioner "file" {
    source      = var.public_key_path
    destination = "/home/ubuntu/.ssh/authorized_keys"
  }

  # Add the private key, so that the Ansible Controller can connect to the private instances
  provisioner "file" {
    source      = var.private_key_path
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

  # modify permissions for the private key
  provisioner "shell" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/id_rsa",
      "chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa"
    ]
  }

  provisioner "shell" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys"
    ]
  }

  post-processor "manifest" {
    output = "manifest-ansible-controller.json"
  }
}
