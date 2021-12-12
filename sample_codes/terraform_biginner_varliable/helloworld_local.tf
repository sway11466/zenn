locals {
  content  = "use local variables."
  filename = "hello_local.txt"
}

resource "local_file" "helloworld" {
  content  = local.content
  filename = local.filename
}
