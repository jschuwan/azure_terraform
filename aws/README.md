# AWS EKS Cluster
## Steps
### Build Cluster
```
terraform init
terraform apply
```
### Kubeconfig
- From cmd run ```terraform output access_key``` to get ID and Secret of new user
- Run the following, substitiuting ID and Secret
```
aws configure --profile personal
<access key>
<secret access key>
us-east-1
json
```
- Run ```aks sts get-caller-identity --profile personal``` to retrieve arn of user
- Run ```aws eks update-kubeconfig --name <cluster name> --region us-east-1``` to add credentials of local account to kubeconfig
- From cmd you’ll need to run the command: ```kubectl edit configmap aws-auth -n kube-system```
- This should open the aws-auth configmap in a text editor and it should look something like this:
- You will need to add the following below mapRoles in the data section
```
mapUsers: |
- userarn: <userarn>
  username: <username>
  groups:
    - system:masters
```

### Users
- Finally, all you need to do is pass along the programmatic access keys for their IAM User, and instructions to set up the kubeconfig with the aws cli
```
aws configure --profile personal
<access key>
<secret access key>
us-east-1
json
```
- Next from cnd run ```aws eks --profile personal update-kubeconfig --name <cluster name> --region <region>```