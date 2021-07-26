provider "aws" {
    # revature config options
}

##### create iam role
resource "aws_iam_role" "eks_cluster_role" {
    name = "eks_cluster_role"

    assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
        })
        tags = {
          var.tags.role_key = var.tags.role_value
        }
}

##### create eks cluster
resource "aws_eks_cluster" "revature" {
    name        = "revatureeks"
    role_arn    = aws_iam_role.eks_cluster_role

    vpc_config {
        subnet_ids = 
    }
  
}