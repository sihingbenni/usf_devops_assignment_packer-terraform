data "template_file" "update_hosts_script" {
  template = file("${path.module}/scripts/update_hosts.sh.tpl")

  vars = {
    ansible_controller_ip = aws_instance.ansible_controller.private_ip
    private_linux_instances = jsonencode(aws_instance.private_linux_instances)
    private_ubuntu_instances = jsonencode(aws_instance.private_ubuntu_instances)
  }
}

resource "null_resource" "update_hosts" {
  connection {
    type        = "ssh"
    host        = aws_instance.bastion.public_ip
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    content     = data.template_file.update_hosts_script.rendered
    destination = "/tmp/update_hosts.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/update_hosts.sh",
      "sudo /tmp/update_hosts.sh"
    ]
  }


}