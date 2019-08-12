resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true // DNSサーバによる名前解決を有効に
  enable_dns_hostnames = true // VPC内のリソースにパブリックDNSホスト名を自動的に割り当てる

  tags = {
    Name = "example"
  }
}

// パブリックサブネット
resource "aws_subnet" "public_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true // そのサブネットで起動したインスタンスにパブリックIPアドレスを自動的に割り当てる
  availability_zone = "ap-northeast-1a"
}

// パブリックサブネット
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true // そのサブネットで起動したインスタンスにパブリックIPアドレスを自動的に割り当てる
  availability_zone = "ap-northeast-1c"
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id // idを指定するだけでインターネットゲートウェイを作成
}

// ネットワークにデータを流すためのルーティング情報を管理するルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

// ルートの定義
resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0" // デフォルトルート
}

// ルートテーブルとサブネットを関連付け
resource "aws_route_table_association" "public_0" {
  subnet_id = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
}

// ルートテーブルとサブネットを関連付け
resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

// ---------------------------------------------------------

// プライベートサブネット
resource "aws_subnet" "private_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.65.0/24" // 別のサブネットとは異なるCIDRブロックを指定
  availability_zone = "ap-northeast-1a"
  map_public_ip_on_launch = false // パブリックIPアドレスは不要
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.66.0/24" // 別のサブネットとは異なるCIDRブロックを指定
  availability_zone = "ap-northeast-1c"
  map_public_ip_on_launch = false // パブリックIPアドレスは不要
}

resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private_0" {
  subnet_id = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}
