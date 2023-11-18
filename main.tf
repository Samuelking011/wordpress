# creating instance resource
resource "aws_instance" "ec2_instance" {
    ami = "${var.ami_id}"
    count = "${var.number_of_instances}"
    subnet_id = aws_subnet.ec2_public[count.index].id
    instance_type = "${var.instance_type}"
    key_name = "${var.ami_key_pair_name}"

    security_groups = [aws_security_group.ec2_elb.id]

    # Read the script content from user_data.sh file
    user_data =  <<-EOF
                 #!/bin/bash
                 # This is user_data1.sh
                 file("user_data.sh") 

                 # Restart the shell
                 exec bash
                 
                 # This is user_data2.sh
                 file("user_data2.sh")


                 EOF

    tags = {
      Name = "Terraform ec2"
    }
   
}