# Toy AWS Infrastructure with terraform

[![Deploy Terraform](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-deploy.yml/badge.svg?branch=main)](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-deploy.yml)

[![Destroy Terraform](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-destroy.yml/badge.svg?branch=main)](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tf-destroy.yml)

[![tfsec](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tfsec.yml/badge.svg)](https://github.com/Kristina-Pianykh/terraform-aws-test-infrastructure/actions/workflows/tfsec.yml)

A simple setup for requesting a service that saves a request data to an Amazon RDS Database. The service is fronted with a public-facing Application Load Balancer that forwards a request to the service hosted on EC2 instances. The CPU load on the instances is regulated via an Autoscaling Group policy that spins up more EC2s if a threshold on average CPU utilization is exceeded. The request data is then encueued to an SQS buffer in the form of a message to prevent data loss in case the RDS Database is overloaded. The security policies ensure that messages are read by the RDS service only. The Database allows access for one local IP address for debugging purposes.
![Drag Racing](terraform-aws-infra.jpg)

It's deployed via Github Workflows (on push) or locally with the `terraform_deploy.sh` script.

To destroy the infrastructure, trigger the workflow `Terraform Destroy` in the GitHub UI.

## Testing

### Test the Autoscaling

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
