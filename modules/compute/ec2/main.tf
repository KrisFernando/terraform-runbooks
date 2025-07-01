# modules/compute/ec2/main.tf
# This module creates a single EC2 instance and an optional EBS volume.
# This is typically used for standalone servers that are not part of an Auto Scaling Group
# or ECS cluster.

resource "aws_instance" "main" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  subnet_id     = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  # Optional: Attach an EBS volume
  dynamic "ebs_block_device" {
    for_each = var.ebs_volumes
    content {
      device_name = ebs_block_device.value.device_name
      volume_size = ebs_block_device.value.volume_size
      volume_type = ebs_block_device.value.volume_type
      encrypted   = lookup(ebs_block_device.value, "encrypted", true)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
    }
  }

  tags = {
    Name        = "${var.environment}-${var.instance_name}"
    Environment = var.environment
  }
}