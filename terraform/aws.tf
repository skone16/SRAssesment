resource "aws_security_group" "sg1" {
  name        = "sg1"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  ingress {
    description = "WEB from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "srv1" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_ami" "centos" {
  most_recent = true


  filter {
    name   = "name"
    values = ["CentOS Linux 7*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = [ "554972078488" ]

}

resource "aws_instance" "srv1" {
  ami  = data.aws_ami.centos.id
  instance_type = var.instance_type
  key_name = aws_key_pair.srv1.key_name
  vpc_security_group_ids = [ aws_security_group.sg1.id ]
  tags = {
    Name = "AssessmentServer1"
  }
}

resource "null_resource" "srv1" { 
    triggers = {
    playbook_file = md5(file("../ansible/nginx_install.yml"))
  }

connection {
    private_key = file("~/.ssh/id_rsa")
    user        = var.ansible_user
    host = aws_instance.srv1.public_ip
  }


provisioner "remote-exec" {
    inline = [ "python -V || yum install python -y" ]

  }

provisioner "local-exec" {
    command = "ansible-playbook -u root -i ${aws_instance.srv1.public_ip} ./ansible/nginx_install.yml "
  }

}



output "public_ip" {
  value = aws_instance.srv1.public_ip
}
