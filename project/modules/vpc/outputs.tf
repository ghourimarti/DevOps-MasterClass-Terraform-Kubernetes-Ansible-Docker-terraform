output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "nat_gateway_id" {
  value = var.create_nat_gateway ? aws_nat_gateway.this[0].id : null
}

output "ssh_security_group_id" {
  value = aws_security_group.ssh.id
}