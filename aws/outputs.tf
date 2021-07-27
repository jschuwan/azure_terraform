output "access_key" {
  value = aws_iam_access_key.eks_user
  sensitive = true
}

output "kubeconfig_file" {
  value = module.eks.kubeconfig
  sensitive = true
}