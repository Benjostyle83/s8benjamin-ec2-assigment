# AWS region
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-East-1"
}

# AMI ID
variable "ami_id" {
  description = "ami-0984f4b9e98be44bf"
  type        = string
}

# Instance Type
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

# Key Pair
variable "key_name" {
  description = "nkbjack"
  type        = string
}

# Subnet ID
variable "subnet_id" {
  description = "subnet-06645389ae6164137"
  type        = string
}

# Security Group IDs
variable "security_group_ids" {
  description = "sg-077d8fe00800a9abc"
  type        = list(string)
  default     = []
}

# Instance Name
variable "instance_name" {
  description = "s8ben-instance"
  type        = string
  default     = "s8ben-instance"
}

# Additional Tags
variable "tags" {
  description = "Additional tags to associate with the instance"
  type        = map(string)
  default     = {}
}

# EBS Volumes
variable "ebs_volumes" {
  description = "List of maps defining EBS volumes to attach, with keys: device_name and volume_id"
  type = list(object({
    device_name = string
    volume_id   = string
  }))
  default = []
}