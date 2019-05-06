/* AWS VPC */
resource "aws_vpc" "icasei_vpc" {
    cidr_block = "172.17.0.0/16"
    tags {
        Name = "icasei-vpc"
    }
}

/* AWS IGW */
resource "aws_internet_gateway" "icasei-igw" {
  vpc_id = "${aws_vpc.icasei_vpc.id}"
}

/* AWS EIP */
resource "aws_eip" "icasei_nat" {
  vpc = true
}

/* AWS NGW */
resource "aws_nat_gateway" "icasei_nat-gw" {
  allocation_id = "${aws_eip.icasei_nat.id}"
  subnet_id = "${aws_subnet.public-sub-a.id}"
  depends_on = [ "aws_internet_gateway.icasei-igw", "aws_subnet.public-sub-a" ]
}

/*Public Route Table*/
resource "aws_route_table" public-sub {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.icasei-igw.id}"
    }

    tags {
        Name = "Public Subnet"
    }
}

/* Private Route Table*/
resource "aws_route_table" "private-sub" {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.icasei_nat-gw.id}"
    }

    tags {
        Name = "Private Subnet"
    }
}

/* Public Subnet A*/
resource "aws_subnet" public-sub-a {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    cidr_block = "172.17.0.0/26"
    availability_zone = "us-east-1a"

    tags {
        Name = "Public Subnet A"
    }
}
resource "aws_route_table_association" public-sub-a {
    depends_on = [ "aws_route_table.public-sub" ]
    subnet_id = "${aws_subnet.public-sub-a.id}"
    route_table_id = "${aws_route_table.public-sub.id}"
}

/* Public Subnet B*/
resource "aws_subnet" "public-sub-b" {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    cidr_block = "172.17.0.64/26"
    availability_zone = "us-east-1b"

    tags {
        Name = "Public Subnet B"
    }
}
resource "aws_route_table_association" "public-sub-b" {
    depends_on = [ "aws_route_table.public-sub" ]
    subnet_id = "${aws_subnet.public-sub-b.id}"
    route_table_id = "${aws_route_table.public-sub.id}"
}

/* Public Subnet C*/
resource "aws_subnet" "public-sub-c" {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    cidr_block = "172.17.0.128/26"
    availability_zone = "us-east-1c"

    tags {
        Name = "Public Subnet C"
    }
}
resource "aws_route_table_association" "public-sub-c" {
    depends_on = [ "aws_route_table.public-sub" ]
    subnet_id = "${aws_subnet.public-sub-c.id}"
    route_table_id = "${aws_route_table.public-sub.id}"
}

/* Private Subnet A */
resource "aws_subnet" "private-subnet-a" {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    cidr_block = "172.17.1.0/26"
    availability_zone = "us-east-1a"

    tags {
        Name = "Private Subnet A"
    }
}
resource "aws_route_table_association" "private-subnet-a" {
    depends_on = [ "aws_route_table.private-sub" ]
    subnet_id = "${aws_subnet.private-subnet-a.id}"
    route_table_id = "${aws_route_table.private-sub.id}"
}

/* Private Subnet B */
resource "aws_subnet" "private-subnet-b" {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    cidr_block = "172.17.1.64/26"
    availability_zone = "us-east-1b"

    tags {
        Name = "Private Subnet B"
    }
}
resource "aws_route_table_association" "private-subnet-b" {
    depends_on = [ "aws_route_table.private-sub" ]
    subnet_id = "${aws_subnet.private-subnet-b.id}"
    route_table_id = "${aws_route_table.private-sub.id}"
}

/* Private Subnet C */
resource "aws_subnet" "private-subnet-c" {
    vpc_id = "${aws_vpc.icasei_vpc.id}"

    cidr_block = "172.17.1.128/26"
    availability_zone = "us-east-1c"

    tags {
        Name = "Private Subnet C"
    }
}
resource "aws_route_table_association" "private-subnet-c" {
    depends_on = [ "aws_route_table.private-sub" ]
    subnet_id = "${aws_subnet.private-subnet-c.id}"
    route_table_id = "${aws_route_table.private-sub.id}"
}

output "public-sub-a" {
  value = "${aws_subnet.public-sub-a.id}"
}

output "public-sub-b" {
  value = "${aws_subnet.public-sub-b.id}"
}

output "public-sub-c" {
  value = "${aws_subnet.public-sub-c.id}"
}

output "private-subnet-a" {
  value = "${aws_subnet.private-subnet-a.id}"
}

output "private-subnet-b" {
  value = "${aws_subnet.private-subnet-b.id}"
}

output "private-subnet-c" {
  value = "${aws_subnet.private-subnet-c.id}"
}
