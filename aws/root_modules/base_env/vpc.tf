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
  source = "hashicorp/subnets/cidr"

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
  source = "hashicorp/subnets/cidr"

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


#
# Nat instance
