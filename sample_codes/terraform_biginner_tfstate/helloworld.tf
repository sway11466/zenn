resource "local_file" "helloworld" {
    content         = "hello world!"
    filename        = "hello.txt"
    file_permission = "0555"
}
