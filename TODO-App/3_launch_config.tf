resource "aws_launch_configuration" "example" {
    image_id = "${var.ami}"
    instance_type = "${var.instance_type}"
    name_prefix = "${var.environment}-${var.application}"
    security_groups = [aws_security_group.instance.id]
    iam_instance_profile = "${aws_iam_instance_profile.todo_profile.name}"
    associate_public_ip_address = true

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

    lifecycle {
        create_before_destroy = true
    }

    enable_monitoring = true

}