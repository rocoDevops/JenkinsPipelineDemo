resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
provisioner "local-exec" {
    command = "echo ${aws_vpc.main.id} >> vpc.txt"
}