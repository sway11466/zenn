module "production_main" {
  source   = "../../modules/hello"
  content  = local.file.content
  filename = local.file.filename
}
