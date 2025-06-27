module "security_group" {
  source = "./modules/security_group"
  vpc_id = var.vpc_id
  name   = "apache-sg"
}

module "ec2" {
  source            = "./modules/ec2"
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  security_group_id = module.security_group.security_group_id
  name              = "apache-ec2"
}
