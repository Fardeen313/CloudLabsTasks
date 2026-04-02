#!/bin/bash

az login

az deployment group create \
  --resource-group FardeenAttar-rg \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.jsonc \
  --verbose

echo "Deployment complete!"
