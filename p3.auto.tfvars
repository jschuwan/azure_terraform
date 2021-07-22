# this is a templete for creating a *.auto.tfvar file.
# the purpose of this file is to pass service principle information
# into the terraform pipeline so we can leverage terraform cloud.
# Please provide the information below from the Azure 
# service pricipal being used in your project. 
# name the file <name>.auto.tfvars and upload 
# to ADO as a secure file.

client_id       = ""
client_secret   = ""
tenant_id       = ""
subscription_id = ""