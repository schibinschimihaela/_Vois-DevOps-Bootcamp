output "vpc_id" {
  value = aws_vpc.cyber.id
}

output "subnet_a_id" {
  value = aws_subnet.a.id
}

output "subnet_b_id" {
  value = aws_subnet.b.id
}

output "security_group_id" {
  value = aws_security_group.mutual_ssh.id
}

output "nodea_private_ip" {
  value = aws_instance.nodea.private_ip
}

output "nodeb_private_ip" {
  value = aws_instance.nodeb.private_ip
}

output "nodea_instance_id" {
  value = aws_instance.nodea.id
}

output "nodeb_instance_id" {
  value = aws_instance.nodeb.id
}

output "eic_endpoint_id" {
  value = aws_ec2_instance_connect_endpoint.eic.id
}
