# terraform-azure-service-bus

Create &amp; Manage Azure Service Bus w/ Terraform

This repository will create an Azure resource group & service bus components
via Terraform.

The following variables are required via either a tfvars file
or one of Terraforms other methods for submitting sensitive variables.

- serviceprinciple_id
- serviceprinciple_key
- tenant_id
- subscription_id

## Service Principal Setup

```shell
SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name aks-getting-started-sp -o json)

#Keep the `appId` and `password` for later use!

SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

#grant contributor role over the resource group to our service principal

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCEGROUP" \
--role Contributor
```
