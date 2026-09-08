data "http" "myip" {
  url = "https://ifconfig.me/ip"
}

module "my_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name            = "tf-vpc-sg"
  use_name_prefix = false
  vpc_id          = module.my_vpc.vpc_id

  ingress_rules = {
    http = {
      cidr_ipv4   = "0.0.0.0/0"
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
    }
    ssh = {
      cidr_ipv4   = "${chomp(data.http.myip.response_body)}/32"
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }

    prometheus = {
      cidr_ipv4   = "${chomp(data.http.myip.response_body)}/32"
      ip_protocol = "tcp"
      from_port   = 9090
      to_port     = 9090
    }
    node_exporter = {
      cidr_ipv4   = "10.20.0.0/16" #Restricts access to internal VPC traffic only
      #cidr_ipv4   = "0.0.0.0/0" #allow external access to Node Exporter metrics on port 9100. violates security best practices
      ip_protocol = "tcp"
      from_port   = 9100
      to_port     = 9100
    }
    
  }

  egress_rules = {
    all = { cidr_ipv4 = "0.0.0.0/0", ip_protocol = "-1" }
  }

  tags = { Name = "tf-vpc-sg" }
}