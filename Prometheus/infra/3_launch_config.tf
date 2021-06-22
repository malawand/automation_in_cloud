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
    sudo wget https://github.com/prometheus/prometheus/releases/download/v2.27.1/prometheus-2.27.1.linux-amd64.tar.gz -P /opt/
    sudo tar -zxvf /opt/prometheus-2.27.1.linux-amd64.tar.gz -C /opt/
    sudo mv /opt/prometheus-2.27.1.linux-amd64 /opt/prometheus/
    sudo aws s3 cp s3://${var.environment}-prometheus/config/prometheus.service /etc/systemd/system/prometheus.service
    sudo aws s3 cp s3://${var.environment}-prometheus/config/prometheus.yml /opt/prometheus/prometheus.yml
    sudo systemctl start node-exporter  
    sudo systemctl start prometheus
    EOF

    lifecycle {
        create_before_destroy = true
    }

    enable_monitoring = true

}