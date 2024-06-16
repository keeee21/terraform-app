# ========================================== #
# Key Pair
# ========================================== #
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./src/terrafrom-app.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# ========================================== #
# EC2 Instance
# ========================================== #
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnets["public-1a"].id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]
  key_name = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-app-server"
    Project = var.project
    Env     = var.environment
    Type    = "app"
  }
}