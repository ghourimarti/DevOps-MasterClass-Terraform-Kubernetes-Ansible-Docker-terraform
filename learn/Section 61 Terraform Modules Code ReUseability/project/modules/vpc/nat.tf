#################################################
# 1. Create aws_eip for NAT
#################################################
#Define External IP 
resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}


#################################################
# 2. Create aws_nat_gateway:  levelup-nat-gw ---> levelupvpc-public-1
#################################################
resource "aws_nat_gateway" "this" {
  count = var.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${var.vpc_name}-nat-gw"
  }
}

# 3,4 = levelupvpc-private-1,2,3 ---> levelup-private ---> levelup-nat-gw
#################################################
# 3. Create aws_route_table: levelup-private ---> levelup-nat-gw
#################################################
resource "aws_route_table" "private" {
  count  =  var.create_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[0].id
  }

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}


#######################################################
# 4. Create aws_route_table_association: levelupvpc-private-1,2,3 ---> levelup-private
#######################################################
# route associations private

resource "aws_route_table_association" "private" {
  count = var.create_nat_gateway ? length(aws_subnet.private) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}