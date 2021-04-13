provider "aws" {
  version = "~> 3.0"
  region = "eu-west-2"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "add-account_lambda" {
  
  filename      = "handler.zip"
  function_name = "add-account"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "main"
  runtime = "go1.x"

  environment {
    variables = {
      API_VERSION = "1.0.0+2021.4"
      ENV = sbx
      NHSMAIL_TABLE_NAME = mr-tpem-db-dyt-tpemail
      REGION = eu-west-2
      NHSMAIL_INDEX_EMAILID = gsi-EmailId
    }
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "mr-tpem-db-dyt-tpemail"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "OrganisationErn"
  range_key      = "AccountErn"

  attribute {
    name = "OrganisationErn"
    type = "S"
  }

  attribute {
    name = "AccountErn"
    type = "S"
  }

  global_secondary_index {
    name               = "gsi-EmailId"
    hash_key           = "gsi-EmailId"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["OrganisationErn"]
  }

  tags = {
    Service     = "tpemail"
    Environment = "sbx"
    Project     = "tpemail"
    Owner       = "tpemail"
  }
}