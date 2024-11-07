

# Set up the AWS provider
provider "aws" {
  region = var.region
}

# Call the EC2 module
module "ec2_instance" {
  source           = "C:/Users/josep/AWS_EC2_MODULE"
  region           = var.region
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  subnet_id        = var.subnet_id
  security_group_ids = var.security_group_ids

  instance_name = "s8ben-instance"
  tags = {
    Environment = "Development"
    Project     = "TerraformExample"
  }
}

# (Optional) Add EBS volume attachment if specified
resource "aws_volume_attachment" "ebs_attachment" {
  count         = length(var.ebs_volumes) > 0 ? length(var.ebs_volumes) : 0
  device_name   = element(var.ebs_volumes[count.index].device_name, count.index)
  volume_id     = element(var.ebs_volumes[count.index].volume_id, count.index)
  instance_id   = aws_instance.this.id
  skip_destroy  = true
}