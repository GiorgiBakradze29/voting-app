resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "main" {
  identifier              = "${var.environment}-db-instance"
  instance_class          = var.db_instance_class
  engine                  = "postgres"
  engine_version          = "15"
  allocated_storage       = 20
  vpc_security_group_ids  = [aws_security_group.main.id]
  username                = var.db_username
  password                = var.db_password
  db_name                    = var.db_name
  db_subnet_group_name    = aws_db_subnet_group.main.name
  skip_final_snapshot     = true

    tags = {
        Name        = "${var.environment}-db-instance"
        Environment = var.environment
    }
}

resource "aws_security_group" "main" {
  name        = "${var.environment}-db-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    }
}