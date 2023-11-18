variable "instance_name" {
        description = "Name of the instance to be created"
        default = "terraform ec2 instance"
}

variable "instance_type" {
        default = "t2.micro"
}

variable "ami_id" {
        description = "The AMI to use"
        default = "ami-0fc5d935ebf8bc3bc"
}

variable "number_of_instances" {
        description = "number of instances to be created"
        default = 1
}


variable "ami_key_pair_name" {
        description = "key pair to access your instance"
        default = "go"
}

variable "app_name" {
    type    = string
    default = "sammy-EC2"
}

variable "app_env" {
    type    = string
    default = "staging"
}

variable "vpc_cidr" {
    description = "IP address range to use in VPC"
    default = "172.16.0.0/16"
}

variable "az_count" {
    description = "Number of Availability zones"
    default     = "2"
}

variable "subnet_count" {
    description = "Number of subnets"
    default     = "2"
}