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
    sudo wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz -P /opt/
    sudo tar -zxvf /opt/node_exporter-1.1.2.linux-amd64.tar.gz -C /opt/
    sudo mv /opt/node_exporter-1.1.2.linux-amd64 /opt/node-exporter/
    sudo aws s3 cp s3://${var.environment}-config/config/node-exporter.service /etc/systemd/system/node-exporter.service
    sudo yum install git -y
    sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
    sudo yum install -y nodejs -y
    sudo systemctl start node-exporter
    sudo git clone https://github.com/kabirbaidhya/react-todo-app.git /opt/todo_app
    sudo npm install --prefix /opt/todo_app/
    sudo npm start --prefix /opt/todo_app/    
    EOF

    lifecycle {
        create_before_destroy = true
    }

    enable_monitoring = true

}