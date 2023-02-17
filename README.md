[![Deploy Terraform](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-deploy.yml/badge.svg)](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-deploy.yml)

[![Destroy Terraform](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-destroy.yml/badge.svg)](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-destroy.yml)

[![tfsec](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tfsec.yml/badge.svg)](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tfsec.yml)

### To test the Autoscaling

- connect to an EC2 instance via AWS Console
- Install the stress testers with:

```bash
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
```

- Run the stress tester with:

```bash
stress -c <cpu_cores>
```

### To run the main GitHub Workflow locally:

- install [`Docker`](https://docs.docker.com/get-docker/)
- install [`act`](https://github.com/nektos/act)

Run a Docker container with:

```bash
act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:full-latest --secret-file my.secrets --env-file aws.env -W .github/workflows/main.yml -e event.json
```

where

- `-P` is the Flag for an image
- `--secret-file` takes the path to the file with secrets
- `--env-file` takes the path to the file with environment variables
- `-W` takes the path to the workflow file
- `-e` takes the path to the event file (in this repo used to skip some jobs)
