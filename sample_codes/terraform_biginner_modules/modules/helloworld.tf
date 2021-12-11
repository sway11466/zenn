variable "content" {
}

variable "filename" {
}

resource "local_file" "helloworld" {
  content  = var.content
  filename = var.filename
}

output "debug_print" {
  value = "${var.content} to ${var.filename}"
}
