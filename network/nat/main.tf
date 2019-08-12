// EIP 静的なパブリックIPアドレス
resource "aws_eip" "nat_gateway_0" {
  vpc = true
  // インターネットゲートウェイへの依存を依存を明示して、IGW作成後に作成する
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "nat_gateway_1" {
  vpc = true
  // インターネットゲートウェイへの依存を依存を明示して、IGW作成後に作成する
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id = aws_subnet.public_0.id // パブリックサブネットを指定
  depends_on = [aws_internet_gateway.example] // インターネットゲートウェイへの依存を依存を明示
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id = aws_subnet.public_1.id // パブリックサブネットを指定
  depends_on = [aws_internet_gateway.example] // インターネットゲートウェイへの依存を依存を明示
}

resource "aws_route" "private_0" {
  route_table_id = aws_route_table.private_0.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_0.id // gateway_idではなくnat_gateway_id
  destination_cidr_block = 0.0.0.0/0
}

resource "aws_route" "private_1" {
  route_table_id = aws_route_table.private_1.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_1.id // gateway_idではなくnat_gateway_id
  destination_cidr_block = 0.0.0.0/0
}
