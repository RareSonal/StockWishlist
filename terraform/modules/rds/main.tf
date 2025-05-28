resource "aws_db_subnet_group" "public" {
  name       = "stockwishlist-db-subnet-public"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "StockWishlist DB Public Subnet Group"
  }
}

resource "aws_db_subnet_group" "private" {
  name       = "stockwishlist-db-subnet-private"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "StockWishlist DB Private Subnet Group"
  }
}

resource "aws_db_instance" "postgres_instance" {
  identifier              = "stockwishlist-postgres"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "stockwishlist"
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = var.use_public_subnet_for_rds
  db_subnet_group_name    = var.use_public_subnet_for_rds ? aws_db_subnet_group.public.name : aws_db_subnet_group.private.name
  vpc_security_group_ids  = [var.security_group_id]

  tags = {
    Name = "StockWishlistPostgres"
  }
}
