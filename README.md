# terraform-azure-service-bus

Create &amp; Manage Azure Service Bus w/ Terraform

The purpose of this repository is to learn/familiarize myself with as many Terraform functions, process as I could fit in. So there may appear to be overdone components... it was with intent. It is a project of my creation for educational purposes.

This repository will create an Azure resource group, service bus components & azure keyvault & secrets to contain topic authorization secrets via Terraform.

The following variables are required via either a tfvars file
or one of Terraform's other methods for submitting sensitive variables.

- serviceprinciple_id (string)
- serviceprinciple_key (string)
- tenant_id (string)
- subscription_id (string)
- user_mail (optional - list)

## Service Principal Setup

```shell
RESOURCEGROUP='<RG_NAME>'
SUBSCRIPTION='<SUBSCRIPTON>'
SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name sb-keyvault-sp -o json)

#Keep the `appId` and `password` for later use!

SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

#grant contributor role over the resource group to our service principal

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCEGROUP" \
--role Contributor

echo "Service Principal: $SERVICE_PRINCIPAL"
echo "Service Principal Secret: $SERSERVICE_PRINCIPAL_SECRETVICE_PRINCIPAL"
```

## How to use

The key component about this Terraform configuration is the use of the config.yaml file. We will control our servicebus infrastructure through the use of this file.

The yaml file in question is in the root directory. It is a fully populated configuration file with comments on each input regarding type and requirements. There's also a `config-minimal.yaml` exampling a minimalist (use defaults) version.

In most cases parent keys and their respective `options` keys are required to keep the configuration working. This is because the config file is processed in the module sb through several for loops. Missing keys can break the local variables.

Each namespace is a list item with an accompanying name. As child items you can create `topics`, `subscriptions` `authroizations` & `queues` at this time. Each of the child items with the exception of the `authorization` have a required name & options field. The `authorization` item only has a name if used.

Note that this is still a work in progress.
