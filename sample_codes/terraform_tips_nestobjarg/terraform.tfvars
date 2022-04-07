subnets = {
  "application-subnet" = {
    cidr   = "192.168.10.0/24"
    public = true
  }
  "database-subnet" = {
    cidr   = "192.168.100.0/24"
    public = false
  }
}
