module "subnets" {
  source = "hashicorp/subnets/cidr"
  base_cidr_block = "10.0.0.0/8"
  networks = [
    { name = "subnet-1a", new_bits = 4 },
    { name = "subnet-1c", new_bits = 4 },
    { name = "subnet-1d", new_bits = 4 },
  ]
}

output all {
  value = module.subnets
}

output ciders {
  value = module.subnets.networks[*].cidr_block
}
