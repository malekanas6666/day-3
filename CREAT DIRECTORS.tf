# creat directors
resource "aws_s3_object" "object-2" {
  bucket = "my-bucket-123-malek"
  key    = "log"
}
resource "aws_s3_object" "object-3" {
  bucket = "my-bucket-123-malek"
  key    = "outgoing"
}
resource "aws_s3_object" "object-4" {
  bucket = "my-bucket-123-malek"
  key    = "incomming"
}

