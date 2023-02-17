#!/usr/bin/env bash

# This script is used to deploy the terraform code to AWS
terraform -chdir=terraform/src init -backend-config=backend.hcl
terraform -chdir=terraform/src apply -var-file=secret.tfvars
