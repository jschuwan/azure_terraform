# AWS EKS Cluster
## Steps
### Build Cluster
```
terraform init
terraform apply
```
### Kubeconfig
- From cmd run `terraform output access_key` to get `ID` and `Secret` of new user
- Run the following, substitiuting `ID` and `Secret`
```
aws configure --profile personal
<access key>
<secret access key>
us-east-1
json
```
- Run `aks sts get-caller-identity --profile personal` to retrieve arn of user
- Run `aws eks update-kubeconfig --name <cluster name> --region us-east-1` to add credentials of local account to kubeconfig
- From cmd you’ll need to run the command: `kubectl edit configmap aws-auth -n kube-system`
- This should open the aws-auth configmap in a text editor and it should look something like this:
```
apiVersion: v1
data:
  mapAccounts: |
    []
  mapRoles: |
    - "groups":
      - "system:bootstrappers"
      - "system:nodes"
      "rolearn": "arn:aws:iam::566445256390:role/default-cluster-name2021072720170339590000000d"
      "username": "system:node:{{EC2PrivateDNSName}}"
  mapUsers: |
    - userarn: <userarn>
      username: <username>
      groups:
        - system:masters
```
- You will need to add the following below mapRoles in the data section
```
mapUsers: |
- userarn: <userarn>
  username: <username>
  groups:
    - system:masters
```
### Troubleshooting
- If you get the following error after 1 apply:
```
Error: Error making request: Get "": dial tcp "": connect: connection refused
│
│   with module.eks.data.http.wait_for_cluster[0],
│   on .terraform/modules/eks/data.tf line *, in data "http" "wait_for_cluster":
    *: data "http" "wait_for_cluster" {
```
- This is due to the cluster name being referenced from the Kubernetes provider before creation
- Run `terraform apply` one more time to resolve

### Users
- Finally, all you need to do is pass along the programmatic access keys for their IAM User, and instructions to set up the kubeconfig with the aws cli
```
aws configure --profile personal
<access key>
<secret access key>
us-east-1
json
```
- Next from cnd run `aws eks --profile personal update-kubeconfig --name <cluster name> --region <region>`