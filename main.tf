# creating instance resource
resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_id}"
    count = "${var.number_of_instances}"
    subnet_id = aws_subnet.ec2_public[count.index].id
    instance_type = "${var.instance_type}"
    key_name = "${var.ami_key_pair_name}"

    security_groups = [aws_security_group.ec2_elb.id]

    user_data = file("user_data.sh")  # Read the script content from user_data.sh file

    tags = {
      Name = "Terraform ec2"
    }
   
}