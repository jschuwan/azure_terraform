terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.3.2"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
}

data "aws_availability_zones" "available" {}

module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "2.66.0"

    name                  = "testing-vpc"
    cidr                  = "192.168.0.0/16"
    azs                   = data.aws_availability_zones.available.names
    private_subnets       = ["192.168.128.0/18", "192.168.192.0/18"]
    public_subnets        = ["192.168.0.0/18", "192.168.64.0/18"]
    enable_nat_gateway    = true
    single_nat_gateway    = false
    enable_dns_hostnames  = true
}

##### create iam role for cluster
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
}

resource "aws_iam_role_policy_attachment" "revature_eksclusterpolicy" {
    policy_arn      = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role            = aws_iam_role.eks_cluster_role.name
}

##### create iam role for node group
resource "aws_iam_role" "eks_node_role" {
  name = "eks_node_role"

 assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "revature_amazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "revature_amazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "revature_amazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

##### create eks cluster
# resource "aws_eks_cluster" "revature" {
#     name        = "revature_eks"
#     role_arn    = aws_iam_role.eks_cluster_role.arn

#     vpc_config {
#         subnet_ids = concat(module.vpc.private_subnets,module.vpc.public_subnets)
#     }
# }

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
provider "kubernetes" {
  host = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.cluster.token
}
module "eks" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = "testing-eks"
  cluster_version = "1.17"
  subnets = concat(module.vpc.private_subnets,module.vpc.public_subnets)
  vpc_id = module.vpc.vpc_id

  # worker_groups = [
  #   {
  #     instance_type = "t1.micro"
  #     asg_max_size = 1
  #   }
  # ]
}

##### create node group
resource "aws_eks_node_group" "revature" {
  cluster_name = "testing-eks"
  node_group_name = "revature"
  node_role_arn = aws_iam_role.eks_node_role.arn
  subnet_ids = concat(module.vpc.private_subnets,module.vpc.public_subnets)
  
  scaling_config {
    desired_size  = 1
    max_size      = 1
    min_size      = 1
  } 
  instance_types = ["t1.micro"]
  depends_on = [
    aws_iam_role_policy_attachment.revature_amazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.revature_amazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.revature_amazonEC2ContainerRegistryReadOnly
  ]
}

##### create iam user for cluster access
resource "aws_iam_user" "eks_user" {
  name = "test_user"
}
resource "aws_iam_access_key" "eks_user" {
  user = aws_iam_user.eks_user.name
}
resource "aws_iam_user_policy" "user_policy" {
  name = "test_user_policy"
  user = aws_iam_user.eks_user.name

  policy = jsonencode(
  {
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "VisualEditor0",
    "Effect": "Allow",
    "Action": [
      "eks:AccessKubernetesApi",
      "eks:DescribeCluster"
    ],
    "Resource": "${module.eks.cluster_arn}"
    }]
  })
}

##### eks config
# output "endpoint" {
#   value = aws_eks_cluster.revature.endpoint
# }

# output "kubeconfig" {
#   value = aws_eks_cluster.revature.certificate_authority[0].data
#   sensitive = true
# }

output "access_key" {
  value = aws_iam_access_key.eks_user
  sensitive = true
}

output "kubeconfig_file" {
  value = module.eks.kubeconfig
}