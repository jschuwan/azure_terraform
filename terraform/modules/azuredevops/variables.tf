# ##### Variables referenced from local module
# variable "project_id" {
#     type = list
#     default = [
#         {
#             name    = "acr-common-testing",
#             id      = "9a591d1a-b59e-4089-a839-aaf3cf17a3a9"
#         },
#         {
#             name    = "acr-team1-testing",
#             id      = "d6293b30-b115-4508-b81b-a6c0d733cfa0"
#         },
#         {
#             name    = "acr-team2-testing",
#             id      = "eb90657a-0d4f-4efc-ab88-854ac581c5a8"
#         },
#         {
#             name    = "acr-team3-testing",
#             id      = "d2963c1a-e6cb-47b0-8d51-e0051b0d446e"
#         },
#     ]
# }

# variable "k8s_id" {
#     type = list
#     default = [
#         {
#             name    = "k8s-team1-testing",
#             id      = "d6293b30-b115-4508-b81b-a6c0d733cfa0"
#         },
#         {
#             name    = "k8s-team2-testing",
#             id      = "eb90657a-0d4f-4efc-ab88-854ac581c5a8"
#         },
#         {
#             name    = "k8s-team3-testing",
#             id      = "d2963c1a-e6cb-47b0-8d51-e0051b0d446e"
#         },
#     ]
# }

# variable "k8s_namespaces" {
#     type = list
#     default = [
#         { name = "team1" },{ name = "team2" },{ name = "team3" }
#     ]
# }

# ##### Variables referenced from main module
# variable "project_info" {
#     type        = string
# }
# variable "token" {
#     type        = string
#     sensitive   = true
# }
# variable "tenant_id" {
#     type        = string
# }
# variable "subscription_id" {
#     type        = string
# }
# variable "subscription_name" {
#     type        = string
# }

# variable "resource_group" {
#     type = string
# }

# variable "azurecr_name" {
#     type = string
# }

# variable "k8s_svc_url_dev" {
#     type = string
# }

# variable "k8s_svc_url_staging" {
#     type = string
# }

# variable "k8s_resource_groups" {
#     type = list
# }

# variable "k8s_cluster_names" {
#     type = list
# }