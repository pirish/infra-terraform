locals {
  http_rules = [for sub in var.private_subnet_cidrs : {
    description = "Allow private subnet traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [sub]
    }
  ]
  https_rules = [for sub in var.private_subnet_cidrs : {
    description = "Allow private subnet traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [sub]
    }
  ]
  merged_sg_rules = concat(local.http_rules, local.https_rules)
}

module "instance_default" {
  source = "../ec2"

  #server_name         = var.server_name != null ? var.server_name : "${module.this.id}-nat"
  context          = module.this.context
  vpc_id           = var.vpc_id
  ami_id           = data.aws_ami.this.id
  instance_type    = var.instance_type
  root_volume_size = 30
  subnet_id        = var.public_subnet
  #associate_public_ip_address = true

  ssh_key_name = var.ssh_key_name
  allow_ssh    = true

  ebs_key_name = var.ebs_key_arn

  security_group_rules = local.merged_sg_rules

  user_data = <<EOF
    sudo yum -y update
    sudo yum install iptables-services -y
    sudo systemctl enable iptables
    sudo systemctl start iptables
    sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.d/custom-ip-forwarding.conf
    sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
    ## Get primary network interface
    sudo /sbin/iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
    sudo /sbin/iptables -F FORWARD
    sudo service iptables save

  EOF


  # env_domain      = data.terraform_remote_state.fig.outputs.private_hosted_zone.name
  # private_zone_id = data.terraform_remote_state.fig.outputs.private_hosted_zone.id

  tags = merge(module.this.tags,

  )
}

resource "aws_eip" "nat" {
  count    = var.attach_public_ip ? 1 : 0
  instance = module.instance_default.id
}
