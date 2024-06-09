# ========================================== #
# Security Group for Web Servers
# ========================================== #
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "${var.project}-${var.environment}-web-sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}

# ========================================== #
# Inbound Rules
# ========================================== #
resource "aws_security_group_rule" "web_sg_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_sg_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_sg_ssh" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ========================================== #
# Outbound Rules
# ========================================== #
resource "aws_security_group_rule" "web_sg_egress" {
  security_group_id = aws_security_group.web_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# ========================================== #
# Security Group for Database
# ========================================== #
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "${var.project}-${var.environment}-db-sg"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

# ========================================== #
# Inbound Rules for Database
# ========================================== #
resource "aws_security_group_rule" "db_sg_mysql" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web_sg.id
}

# ========================================== #
# Outbound Rules for Database
# ========================================== #
resource "aws_security_group_rule" "db_sg_egress" {
  security_group_id = aws_security_group.db_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}