locals {
  files = {
    "hello" = {
      name    = "hello.txt"
      content = "hello wolrd."
    }
    "foobar" = {
      name    = "foobar.txt"
      content = "foo bar."
    }
  }
}

resource "local_file" "local_sample" {
  for_each = local.files
  filename = each.value.name
  content  = each.value.content
}
