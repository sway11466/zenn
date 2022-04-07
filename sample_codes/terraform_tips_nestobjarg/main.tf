variable subnets {
  type = map(object({
    cidr   = string
    public = bool
  }))
}

output print-all {
  value = var.subnets
}

output print-keys {
  value = [for k, v in var.subnets : k]
}
