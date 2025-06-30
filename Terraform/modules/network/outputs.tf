output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id 
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id 
}

output "web_sg_id" {
  value = aws_security_group.web_sg.id
}
output "db_sg_id" {
  value = aws_security_group.db_sg.id 
}