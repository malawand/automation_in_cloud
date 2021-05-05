resource "aws_launch_configuration" "example" {
    image_id                  = "ami-048f6ed62451373d9"
    instance_type           = "t2.micro"
    name_prefix             = "${var.environment}-${var.application}"
    security_groups         = [aws_security_group.instance.id]
    iam_instance_profile    = "${aws_iam_instance_profile.todo_profile.name}"
    associate_public_ip_address = false
 
    # Try to manually type it in
    user_data       = <<-EOF
    #!/bin/bash -i
    sudo yum install git -y
    sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
    sudo yum install -y nodejs -y
    sudo git clone https://github.com/kabirbaidhya/react-todo-app.git /opt/todo_app
    sudo npm install --prefix /opt/todo_app/
    sudo npm start --prefix /opt/todo_app/
    EOF
    
    # Required when using a launch configuration with an autoscaling group
    # Since auto-scaling groups cannot be modified, we cannot update the resource in place
    # We must destroy the existing object and then create a new replacement object with the new configured arguments
    lifecycle {
        create_before_destroy = true
    }
    enable_monitoring           = false
}