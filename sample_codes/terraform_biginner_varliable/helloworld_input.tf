variable content {
  default = "use input variables default value."
}
variable filename {
  default = "default_var.txt"
}
resource "local_file" "helloworld" {
  content  = var.content
  filename = var.filename
}
