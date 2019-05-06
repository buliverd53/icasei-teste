/* EC2 Security Group */
resource "aws_security_group" "allow_http_https" {
  description = "Allow HTTP HTTPS inbound traffic"
  vpc_id      = "${aws_vpc.icasei_vpc.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["172.17.0.0/16"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

/* IAM EC2 Instance Profile */
resource "aws_iam_role_policy" "test_policy" {
  role = "${aws_iam_role.ec2_iam_profile.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
resource "aws_iam_instance_profile" "ec2_profile" {
  role = "${aws_iam_role.ec2_iam_profile.name}"
}
resource "aws_iam_role" "ec2_iam_profile" {
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

/* Public Docker Cluster */
resource "aws_launch_configuration" "public_docker_cluster_lc" {
  name_prefix   = "public_docker_cluster"
  image_id      = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  key_name = "admin"
  security_groups = [ "${aws_security_group.allow_http_https.id}" ]
  associate_public_ip_address = "true"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
  user_data = "${file("start.sh")}"
}

resource "aws_autoscaling_group" "public_docker_cluster_asg" {
  depends_on               = [ "aws_launch_configuration.public_docker_cluster_lc" ]
  name_prefix              = "public_docker_cluster_asg"
  vpc_zone_identifier      = [ "${aws_subnet.public-sub-b.id}", "${aws_subnet.public-sub-a.id}", "${aws_subnet.public-sub-c.id}" ]
  desired_capacity         = 3
  max_size                 = 3
  min_size                 = 3
  launch_configuration     = "${aws_launch_configuration.public_docker_cluster_lc.id}"
  tags = [
    {
      key                  = "name"
      value                = "public_docker_cluster"
      propagate_at_launch  = true
    }
  ]
}

/* Private Docker Worker */
resource "aws_launch_configuration" "private_docker_workers_lc" {
  name_prefix   = "private_docker_workers"
  image_id      = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  key_name = "admin"
  security_groups = [ "${aws_security_group.allow_http_https.id}" ]
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
  user_data = "${file("start-worker.sh")}"
}
resource "aws_autoscaling_group" "private_docker_workers_asg" {
  depends_on               = [ "aws_launch_configuration.private_docker_workers_lc" ]
  name_prefix              = "private_docker_workers_asg"
  vpc_zone_identifier      = [ "${aws_subnet.private-subnet-b.id}", "${aws_subnet.private-subnet-a.id}", "${aws_subnet.private-subnet-c.id}" ]
  desired_capacity         = 3
  max_size                 = 3
  min_size                 = 3
  launch_configuration     = "${aws_launch_configuration.private_docker_workers_lc.id}"
  tags = [
    {
      key                  = "name"
      value                = "private_docker_workers"
      propagate_at_launch  = true
    }
  ]
}