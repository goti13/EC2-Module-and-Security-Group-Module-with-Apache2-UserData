# EC2-Module-and-Security-Group-Module-with-Apache2-UserData

# Purpose:

This mini project demostrates the use of Terraform to create modularized configurations for deploying an EC2 instance with a specified Security Group and Apache2 installed using UserData.
Objectives:
1. Terraform Module Creation:

- Learn how to create Terraform modules for modular infrastructure provisioning.
  
2. EC2 Instance Configuration:
   
- Configure Terraform to create an EC2 instance.
  
3. Security Group Configuration:
   
- Create a separate module for the Security Group associated with the EC2 instance.
  
4. UserData Script:
   
- Utilize UserData to install and configure Apache2 on the EC2 instance.
  
# Project Tasks:

Task 1: EC2 Module

1. ﻿﻿﻿Create a new directory for your Terraform project (e.g., 'terraform-ec2-apache*).
2. ﻿﻿﻿Inside the project directory, create a directory for the EC2 module (e.g., 'modules/ec2').
3. ﻿﻿﻿Write a Terraform module ('modules/ec2/main.tf') to create an EC2 instance.

Task 2: Security Group Module

1. ﻿﻿﻿Inside the project directory, create a directory for the Security Group module (e.g., 'modules/security_group*).
2. ﻿﻿﻿Write a Terraform module (modules/security_group/main. tf') to create a Security Group for the EC2 instance.
   
Task 3: UserData Script
1. ﻿﻿﻿Write a UserData script to install and configure Apache2 on the EC2 instance. Save it as a separate file (e.g., 'apache_userdata. sh*).
2. ﻿﻿﻿Ensure that the UserData script is executable (chmod +x apache_userdata.sh*).
   
Task 4: Main Terraform Configuration
1. ﻿﻿﻿Create the main Terraform configuration file ('main.tf') in the project directory.
2. ﻿﻿﻿Use the EC2 and Security Group modules to create the necessary infrastructure for the EC2 instance.
   
Task 5: Deployment
1. ﻿﻿﻿Run 'terraform init' and 'terraform apply' to deploy the EC2 instance with Apache2.
2. ﻿﻿﻿Access the EC2 instance and verify that Apache2 is installed and running.


```
#############################
PROJECT IMPLEMENTATION
#############################
```

**Directory Structure:**

```
terraform-ec2-apache/
├── main.tf
├── variables.tf
├── outputs.tf
├── apache_userdata.sh             # UserData script
├── modules/
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── security_group/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf

```

**modules/ec2/main.tf file**

```
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

```

**modules/ec2/variables.tf file**

```

variable "ami" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "name" {}

```

**modules/ec2/outputs.tf file**


```
output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

```

**modules/security_group/main.tf file**

```
resource "aws_security_group" "this" {
  name        = var.name
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

```

**modules/security_group/variables.tf file**

```
variable "vpc_id" {}
variable "name" {}

```


**modules/security_group/outputs.tf file**


```
output "security_group_id" {
  value = aws_security_group.this.id
}

```

**apache_userdata.sh file**

```
#!/bin/bash
apt-get update
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2
echo "<h1>Apache is running on $(hostname -f)</h1>" > /var/www/html/index.html

```

make the scrip executable


```
chmod +x apache_userdata.sh

```

**main.tf file in root module**

```
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

```


**variables.tf file in root module**

```
variable "vpc_id" {
  description = "VPC ID where the EC2 instance will be deployed"
  default = "vpc-0d82ef8de61ca2566"
}

variable "ami" {
  description = "AMI ID for the EC2 instance"
  default = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro" # optional default
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  default = "subnet-045afed399a8859df"
}

```

![image](https://github.com/user-attachments/assets/21773dfb-eddc-4372-a131-d53fef2c82d7)


![image](https://github.com/user-attachments/assets/e3fdaffa-364c-491b-981f-c8bef8000182)

![image](https://github.com/user-attachments/assets/1c34bf0d-9f0f-4e9f-84bd-a29fb0450c4d)

![image](https://github.com/user-attachments/assets/46b02b54-8c2d-4dae-8bd8-64811f77537e)

![image](https://github.com/user-attachments/assets/58eca8d3-cf7d-437d-9536-9cb8eb66770e)


![image](https://github.com/user-attachments/assets/d6ecb46e-ef7f-47d4-ab43-ed25e798672e)

![image](https://github.com/user-attachments/assets/367e48d9-d623-4b6c-ba8f-05df8f78568d)


![image](https://github.com/user-attachments/assets/6b5996a6-7133-48bf-b4e1-bafc96144da5)


![image](https://github.com/user-attachments/assets/846c4353-cd76-4e6d-bf91-9b729a66c238)



<img width="951" alt="image" src="https://github.com/user-attachments/assets/0285b7e0-fd35-4e68-8253-bcce53aa1425" />


<img width="977" alt="image" src="https://github.com/user-attachments/assets/bf581948-f88a-4dfa-95f7-fdbfc039b849" />

![image](https://github.com/user-attachments/assets/5e41aa15-914b-4561-afbe-2e52ca888c25)


![image](https://github.com/user-attachments/assets/e475100d-4bf8-4281-86a6-f4158e3e9f43)







