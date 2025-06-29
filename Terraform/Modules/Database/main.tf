resource "aws_db_subnet_group" "this" {
  name       = "${var.env_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.env_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.env_name}-postgres"
  engine                 = "postgres"
  engine_version         = "15.8"
  instance_class         = "db.t3.micro"
  allocated_storage      = 10
  max_allocated_storage  = 15
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = 5432
  publicly_accessible    = false
  multi_az               = false
  storage_encrypted      = false 
  backup_retention_period = 7
  skip_final_snapshot    = true
  deletion_protection    = false

  vpc_security_group_ids  = [var.db_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.this.name

  # monitoring_interval = 60
  # monitoring_role_arn  = aws_iam_role.rds_monitoring_role.arn

  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade"
  ]

  tags = {
    Name = "${var.env_name}-postgres"
  }
}
