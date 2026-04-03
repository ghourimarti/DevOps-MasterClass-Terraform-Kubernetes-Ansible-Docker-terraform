#################################################
#                 1. Create aws_eip
#################################################
#Define External IP 
resource "aws_eip" "levelup-nat" {
  domain = "vpc" #vpc = true
}


#################################################
#                 2. Create aws_nat_gateway
#################################################
resource "aws_nat_gateway" "levelup-nat-gw" {
  allocation_id = aws_eip.levelup-nat.id
  subnet_id     = aws_subnet.levelupvpc-public-1.id
  depends_on    = [aws_internet_gateway.levelup-gw]
  tags = {
    Name = "levelup-nat-gw"
  }
}


#################################################
#                 3. Create aws_route_table
#################################################
resource "aws_route_table" "levelup-private" {
  vpc_id = aws_vpc.levelupvpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.levelup-nat-gw.id
  }

  tags = {
    Name = "levelup-private"
  }
}


#######################################################
#                 4. Create aws_route_table_association
#######################################################
# route associations private
resource "aws_route_table_association" "level-private-1-a" {
  subnet_id      = aws_subnet.levelupvpc-private-1.id
  route_table_id = aws_route_table.levelup-private.id
}

resource "aws_route_table_association" "level-private-1-b" {
  subnet_id      = aws_subnet.levelupvpc-private-2.id
  route_table_id = aws_route_table.levelup-private.id
}

resource "aws_route_table_association" "level-private-1-c" {
  subnet_id      = aws_subnet.levelupvpc-private-3.id
  route_table_id = aws_route_table.levelup-private.id
}


#######################################################
#                 5. output
#######################################################
output "____________________aws_nat_gateway___________________" {
  value = {
    aws_eip____________________________ = aws_eip.levelup-nat
    aws_nat_gateway____________________________ = aws_nat_gateway.levelup-nat-gw
    aws_route_table____________________________ = aws_route_table.levelup-private
    aws_route_table_association_1a____________________________ = aws_route_table_association.level-private-1-a
    aws_route_table_association_1b____________________________ = aws_route_table_association.level-private-1-b
    aws_route_table_association_1c____________________________ = aws_route_table_association.level-private-1-c
  }
}