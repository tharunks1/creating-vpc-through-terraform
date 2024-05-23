resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "roboshop-vpc"
    Environment = "DEV"
    Terraform = "true" 
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "roboshop-public"
  }
}


resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "roboshop-private"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-igw"
  }
}

#public route table will have igw attached 
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "roboshop-public"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "roboshop-private"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_route.id
}

# resource "aws_security_group" "allow_tls" {
#   name        = "allow_http_ssh"
#   description = "Allow TLS inbound traffic and all outbound traffic"
#   vpc_id      = aws_vpc.main.id

#   tags = {
#     Name = "allow_http_ssh"
#   }
# }

resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "allow tls inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["223.185.44.163/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
  Name = "allow_http_ssh"
}

}

resource "aws_instance" "web" {
  ami = "ami-0f3c7d07486cad139"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]
  associate_public_ip_address = false

  tags = {
    Name = "roboshop-vpc"
  }

}



