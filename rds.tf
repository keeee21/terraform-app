# ========================================== #
# RDS Parameter Group
# ========================================== #
resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-${var.environment}-mysql-standalone-parametergroup"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
}

# ========================================== #
# RDS Option Group
# ========================================== #
resource "aws_db_option_group" "mysql_standalone_optiongroup" {
  name                 = "${var.project}-${var.environment}-mysql-standalone-optiongroup"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

# ========================================== #
# RDS Subnet Group
# ========================================== #
resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name        = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  description = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
  subnet_ids  = [for subnet in aws_subnet.private_subnets : subnet.id]

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}

# ========================================== #
# RDS instance
# ========================================== #
resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "mysql_standalone" {
  engine            = "mysql"
  engine_version    = "8.0"
  identifier_prefix = "${var.project}-${var.environment}-mysql-standalone"
  username          = "admin"
  password          = random_string.db_password.result
  instance_class    = "db.t2.micro"

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp2"
  storage_encrypted     = false

  multi_az               = false
  availability_zone      = "ap-northest-1a"
  db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  port                   = 3306

  name                 = var.project
  parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
  option_group_name    = aws_db_option_group.mysql_standalone_optiongroup.name

  backup_window              = "04:00-05:00"
  backup_retention_period    = 7
  maintenance_window         = "Mon:05:00-Mon:08:00"
  auto_minor_version_upgrade = false

  deletion_protection = true
  skip_final_snapshot = false
  apply_immediately   = true

  tags = {
    Name    = "${var.project}-${var.environment}-mysql-standalone"
    Project = var.project
    Env     = var.environment
  }
}