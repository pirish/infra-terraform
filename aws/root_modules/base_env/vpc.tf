module "vpc_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  tags = {
  }
  context = module.this.context

}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(tomap({
    "Name" = "${module.vpc_label.id}-vpc"
    }),
    module.vpc_label.tags
  )

  # lifecycle {
  #   ignore_changes = [

  #   ]
  # }
}

module "subnet_addrs" {
  source  = "hashicorp/subnets/cidr"
  version = "v1.0.0"

  base_cidr_block = var.vpc_cidr
  networks = [
    {
      name     = "public"
      new_bits = 2
    },
    {
      name     = "private-1"
      new_bits = 2
    },
    {
      name     = "private-2"
      new_bits = 2
    },
    {
      name     = "private-3"
      new_bits = 2
    },
  ]
}

module "subnet_addrs_public" {
  source  = "hashicorp/subnets/cidr"
  version = "v1.0.0"

  base_cidr_block = module.subnet_addrs.network_cidr_blocks["public"]
  networks = [
    {
      name     = "public-1"
      new_bits = 2
    },
    {
      name     = "public-2"
      new_bits = 2
    },
    {
      name     = "public-3"
      new_bits = 2
    },
    {
      name     = "inspection"
      new_bits = 2
    }
  ]
}

resource "aws_subnet" "public" {
  for_each   = { for key, value in module.subnet_addrs_public.network_cidr_blocks : key => value if startswith(key, "public-") }
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value

  tags = merge(
    tomap({
      Name = "${module.vpc_label.id}-vpc-subnet-${each.key}"
    }),
    module.vpc_label.tags,
  )

  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "aws_subnet" "private" {
  for_each   = { for key, value in module.subnet_addrs.network_cidr_blocks : key => value if startswith(key, "private-") }
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value

  tags = merge(tomap({
    Name = "${module.vpc_label.id}-vpc-subnet-${each.key}"
    }),
    module.vpc_label.tags
  )

  lifecycle {
    ignore_changes = [
    ]
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(tomap({
    Name = "${module.vpc_label.id}-vpc-internet-gw"
    }),
    module.vpc_label.tags
  )
}

# resource "aws_eip" "igw" {
#   instance = module.instance_default.id
# }


# resource "aws_route" "igw" {
#   route_table_id              = aws_vpc.main.main_route_table_id
#   destination_ipv6_cidr_block = "0.0.0.0/0"
#   gateway_id      = aws_internet_gateway.gw.id

# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(tomap({
    Name = "${module.vpc_label.id}-vpc-public-rt"
    }),
    module.vpc_label.tags
  )
}

resource "aws_route_table_association" "public_subnet_association" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}
#
# Nat instance
module "instance_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name = "nat"
  # tags = {
  # }
  context = module.this.context

}
module "nat_instance" {
  source = "../../modules/nat_instance"

  #server_name = "${module.vpc_label.id}-nat-ec2"
  vpc_id               = aws_vpc.main.id
  public_subnet        = aws_subnet.public["public-1"].id
  private_subnet_cidrs = [for key, value in module.subnet_addrs.network_cidr_blocks : value if startswith(key, "private-")]
  ssh_key_name         = aws_key_pair.ec2.key_name
  ebs_key_arn          = aws_kms_key.ec2_key.arn

  context = module.instance_label.context
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat_instance.eni_id
}
