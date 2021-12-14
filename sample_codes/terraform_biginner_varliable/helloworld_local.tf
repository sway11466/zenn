locals {
  content  = "use local values."
  filename = "hello_local.txt"
}
resource "local_file" "helloworld" {
  content  = local.content
  filename = local.filename
}
