provider "aws" {
	region = "us-east-1"
}

#Create vpc
resource "aws_vpc" "main"{
	cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet1_AZ1"{
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.1.0/24"
	availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet1_AZ2"{
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.4.0/24"
	availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet1_AZ1"{
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.2.0/24"
	availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet1_AZ2"{
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.5.0/24"
	availability_zone = "us-east-1b"
}

resource "aws_subnet" "private_subnet2_AZ1"{
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.3.0/24"
	availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet2_AZ2"{
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.6.0/24"
	availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "igw_1"{
	vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route_table"{
	vpc_id = aws_vpc.main.id
	
	route{
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw_1.id
	}
}

resource "aws_route_table_association" "public_subnet1_AZ1_rt_association"{
	subnet_id = aws_subnet.public_subnet1_AZ1.id
	route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet1_AZ2_rt_association"{
	subnet_id = aws_subnet.public_subnet1_AZ2.id
	route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_eip"{
    domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway_1"{
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet1_AZ1.id
}


resource "aws_route_table" "private_route_table"{
    vpc_id = aws_vpc.main.id

    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gateway_1.id
    }
}

resource "aws_route_table_association" "private_subnet_AZ1_rt_association"{
    subnet_id = aws_subnet.private_subnet1_AZ1.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet1_AZ2_rt_association"{
    subnet_id = aws_subnet.private_subnet1_AZ2.id
    route_table_id = aws_route_table.private_route_table.id
}
