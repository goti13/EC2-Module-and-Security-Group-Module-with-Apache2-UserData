resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  user_data                   = file("${path.module}/../../apache_userdata.sh")
  associate_public_ip_address = true

  tags = {
    Name = var.name
  }
}
