
/* ransition all files under /log to Archive access (i.e. Glacier) 90 consecutive days after creation time.
Transition all files under /log to Deep Archive access (i.e. Glacier Deep Archive) 180 consecutive days after creation time.
 Remove all files under /log 365 consecutive days after creation time.
 */
resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.bucket-1.id

  rule {
    id = "under-log"

    expiration {
      days = 360
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER" 
    }
  }
}
/*Transition all files under /outgoing with tag "notDeepArchive" to infrequent access (i.e. Standard-IA) 30 consecutive days after creation time.
 Transition all files under /outgoing to Archive access (i.e. Glacier) with tag "notDeepArchive" 90 consecutive days after creation time.
*/
resource "aws_s3_bucket_lifecycle_configuration" "tags-" {
  bucket = aws_s3_bucket.bucket-1.id

  rule {
    id = "tages"

    filter {
      prefix = "outgoing/"
      tag {
        key   = "notDeepArchive"
        value = "true"
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER"  # التأكد من استخدام القيمة الصحيحة
    }
  }
}
/* Transition all files under /incoming with size between 1MB to 1G to infrequent access (i.e. Standard-IA) 30 consecutive days after creation time.
 Transition all files under /incoming with size between 1MB to 1G to Archive access (i.e. Glacier) 90 consecutive days after creation time.
*/
resource "aws_s3_bucket_lifecycle_configuration" "size-" {
  bucket = aws_s3_bucket.bucket-1.id

  rule {
    id = "size-range"

    filter {
      and {
        prefix                   = "incoming/"
        object_size_greater_than = 1000000
        object_size_less_than    = 1000000000
      }
    }

    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 90
      storage_class = "GLACIER" 
    }
  }
}
