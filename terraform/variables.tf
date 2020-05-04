variable "vpc_id" {
    default =  "vpc-25a66d5f"
}

variable "ami_id" {
    default = "ami-0915e09cc7ceee3ab"
}

variable "instance_type" {
    default = "t2.small"
}

variable "ssh_key_name" {
default  = "saipersonal"
}

variable "security_group_ids" {
    type = list
    default = ["sg-12345678"]
}

variable "ansible_user" {
  default = "centos"
}

   



