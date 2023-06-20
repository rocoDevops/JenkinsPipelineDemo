//Complete name of the resource is resourcetype.resourcename = aws_vpc.main . Name of the resource can be change.
//resource is the key word here "aws_vpc" --> Type of the resource we are creating. 
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Automate-VPC"
    Company = var.Company
    
  }
}
//Creating subnet using terraform
resource "aws_subnet" "Public-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public-subnet-1"
    Company = var.Company
  }
}
resource "aws_subnet" "Private-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Private-subnet-1"
    Company = var.Company
  }
}
resource "aws_subnet" "Public-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Public-subnet-2"
    Company = var.Company
  }
}
resource "aws_subnet" "Private-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Private-subnet-2"
    Company = var.Company
  }
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "IGW"
  }
}
resource "aws_eip" "EIP" {
  domain   = "vpc"
}
resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = aws_subnet.Public-1.id

  tags = {
    Name = "NAT"
  }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_internet_gateway.IGW.id"
  }
  tags = {
    Name = "Public-rt"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "aws_nat_gateway.NAT.id"
  }
  tags = {
    Name = "Private-rt"
  }
}
resource "aws_route_table_association" "Public1" {
  subnet_id      = aws_subnet.Public-1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "Public2" {
  subnet_id      = aws_subnet.Public-2.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "Private1" {
  subnet_id      = aws_subnet.Private-1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "Private2" {
  subnet_id      = aws_subnet.Private-2.id
  route_table_id = aws_route_table.private.id
}
resource "aws_security_group" "SG-Automation" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from anywhere"
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Automation"
  }
}
resource "aws_key_pair" "Automation-key" {
  key_name   = "Automation-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDlfWHyfkwPtKSTkNI4NJJtQC/zIrWHLN2+xUFWzXmf91u61LnEXqAfKk7TlhcZDdHgPFLcr2sdB2rGtd4+58gPwduGOhebRi2aAICJ1Wzhm/wymx8TG0woBB56nw5aRFa6CScgyc7ISHKBWQeFNRMClaf+ijiZIb8yprhtWP2GfWpF4zxYKNSEjwSpEecW9KoViJziiqfrposMGCKJDgTYt8vQdUHHo4rOFxWMN1J4dhU22Yv7jfoOzQrWxswz1XdXjnhTvpcSYZDVhsy24pTXM1ccM/Qy2CXzLh5AR6ma86c/P9Df0fnFuxqMLMr6xQYEcx7etTMmuuWznY05zCt4NkaN+mk/LBAEtDptfLkQwfN1SmFURSwlfU6qQjbD5gr1NJNRULlMlm2d6xkYLEjS6l9vC25cOB1GzOH+Dri+JjgM4NLd3x6voLTNdWskrjSWkamiCrv0TyEsG+ZpepL557YyUxNfJM342eoBoKX3cm2yezk9eZ2j2gTTc3VpAyc= Chandan Debnath@LAPTOP-N3BGVP7G"
}
resource "aws_instance" "Final-Terra-Instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.small"
  key_name = aws_key_pair.Automation-key.key_name
  subnet_id = aws_subnet.Public-1.id
  security_groups = [aws_security_group.SG-Automation.id]
  associate_public_ip_address = true
  
  tags = {
    Name = "Automation-TerraIns"
  }
}



