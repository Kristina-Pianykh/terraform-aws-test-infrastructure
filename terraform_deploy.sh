#!/usr/bin/env bash

# This script is used to deploy the terraform code to AWS


LOCAL_DEPLOYMENT="$1"
PYTHON_IMAGE_CAHCED="./ci/cache/docker/python-image/build-python3.9-1.81.0.tar"

create_lambda_layer () {
    poetry export -f requirements.txt --output requirements.txt --only lambda
    mkdir -p python/lib/python3.9/site-packages

    if [ ! -f  "$PYTHON_IMAGE_CAHCED" ]; then
        docker pull public.ecr.aws/sam/build-python3.9:1.81.0 && mkdir -p ci/cache/docker/python-image && docker image save public.ecr.aws/sam/build-python3.9:1.81.0 --output ./ci/cache/docker/python-image/build-python3.9-1.81.0.tar
    fi
    docker image load --input ./ci/cache/docker/python-image/build-python3.9-1.81.0.tar
    docker run -v "$PWD":/var/task "public.ecr.aws/sam/build-python3.9" /bin/sh -c "pip install -r requirements.txt -t python/lib/python3.9/site-packages/; exit"
    zip -r terraform/src/lambda_layer_payload.zip python > /dev/null
}

apply_terraform () {
    terraform -chdir=terraform/src init -backend-config=backend.hcl
    if [ LOCAL_DEPLOYMENT==1 ]; then
        terraform -chdir=terraform/src plan -var-file=secret.tfvars -out=terraform.plan
    else
        terraform plan \
            -var 'db_username=${{ secrets.DB_USERNAME }}' \
            -var 'db_password=${{ secrets.DB_PASSWORD }}' \
            -var 'my_ip_addresses=${{ secrets.IP_ADDRESSES }}' \
            -out=terraform.plan
    fi
    terraform -chdir=terraform/src apply terraform.plan
}

deploy () {
    create_lambda_layer
    apply_terraform
}

deploy

# if [ echo "$($!)" != "0" ]; then
#     echo "ERROR: Failed to deploy terraform code."
#     rm requirements.txt
#     rm terraform/src/mypythonlibs.zip
# fi

rm requirements.txt
rm terraform/src/lambda_layer_payload.zip
rm terraform/src/sqs_polling.zip
rm terrafrom/src/terraform.plan
sudo rm -rf python
