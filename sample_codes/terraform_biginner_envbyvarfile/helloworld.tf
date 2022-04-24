variable "file" {}

resource "local_file" "env_by_varfile_sample" {
  content  = var.file.content
  filename = var.file.filename
}

output "debug_print" {
  value = "${var.file.content} to ${var.file.filename}"
}
