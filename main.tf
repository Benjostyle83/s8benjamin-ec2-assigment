provider "aws" {
  region = "us-east-1"  
}

# Create a VPC
resource "aws_vpc" "s8ben_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "s8ben_vpc"
  }
}

# Create a subnet
resource "aws_subnet" "s8ben_subnet" {
  vpc_id            = aws_vpc.s8ben_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "s8ben_subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "s8ben_igw" {
  vpc_id = aws_vpc.s8ben_vpc.id
  tags = {
    Name = "s8ben_igw"
  }
}

# Create a route table
resource "aws_route_table" "s8ben_route_table" {
  vpc_id = aws_vpc.s8ben_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.s8ben_igw.id
  }
  tags = {
    Name = "s8ben_route_table"
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "s8ben_route_table_association" {
  subnet_id      = aws_subnet.s8ben_subnet.id
  route_table_id = aws_route_table.s8ben_route_table.id
}

# Create a security group with SSH and SSM access
resource "aws_security_group" "s8ben_sg" {
  vpc_id = aws_vpc.s8ben_vpc.id

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSM (HTTPS) access
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "s8ben_sg"
  }
}

# Create an IAM role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "s8ben_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach SSM policy to the role
resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create an instance profile and attach the role
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "s8ben_instance_profile"
  role = aws_iam_role.ssm_role.name
}

# Launch an EC2 instance
resource "aws_instance" "s8ben_instance" {
  ami                    = "ami-0984f4b9e98be44bf"  
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.s8ben_subnet.id
  security_groups        = [aws_security_group.s8ben_sg.name]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name

  tags = {
    Name = "s8ben_instance"
  }
}

output "instance_id" {
  value = aws_instance.s8ben_instance.id
}

output "instance_public_ip" {
  value = aws_instance.s8ben_instance.public_ip
}