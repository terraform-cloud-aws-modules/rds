# terraform rds module

#### Requirements

 - aws cli (with working credentials)

## Goal

Creating a RDS Cluster with a random passwort via AWS Secrets Manager and a subset of instances

## Install terraform

On Mac:

    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

## Create your terraform base Structure

I would advise you to start with this:

    .
    ├── config
    │   └── aws-dev.tfvars
    ├── main.tf
    ├── outputs.tf
    └── variables.tf

    1 directory, 4 files

### tfvars

"config" is home for different *.tfvars files in different environments.
In this example we're starting with one *.tfvars file.

#### aws-dev.tfvars

Please put the following code in your aws-dev.tfvars:

    profile		= "default"
    region		= "eu-central-1"

    tags = {
      environment     = "testing"
      team            = "terraformers"
      project         = "aws"
    }

##### Optional

Install terragrunt
Mac:

    brew install terragrunt

and split your config into something like:

    .
    └── config
        └── aws-dev
            ├── common.tfvars
            └── region.tfvars

In your root folder (where your main.tf is located) create "terragrunt.hcl" with this content:

    terraform {
      extra_arguments "common_vars" {
        commands = ["plan", "apply"]

        arguments = [
          "-var-file=config/aws-dev/region.tfvars",
          "-var-file=config/aws-dev/common.tfvars"
        ]
      }
    }

### main.tf

Create the main.tf with the following code:

    provider "aws" {
      profile = var.profile
      region  = var.region
      version = "3.12.0"
    }
    module "rds" {
      source               = "git@github.com:terraform-cloud-aws-modules/rds.git"
      rds_clustername      = "YOURCLUSTERNAME"
      rds_engine           = "aurora-postgresql"
      rds_az               = ["eu-central-1a", "eu-central-1b"]
      rds_db_name          = "DBNAME"
      rds_master_user      = "ROOT"
      rds_master_pw        = ""
      rds_backup_retention = "2"
      rds_backup_window    = "07:00-09:00"
      tags                 = var.tags
    }

### variables.tf

You have to declare variables from tfvars file like:

    variable "profile" {
      type        = string
      description = "provider profile"
    }

    variable "region" {
      type        = string
      description = "provider region"
    }

    variable "tags" {
        type        = map
        description = "Tags used for AWS resources"
    }

### outputs.tf

You can use the outputs from the module in this file like:

    output "rds_arn" {
      value = module.rds.this_rds_cluster_arn
    }

    output "rds_endpoint" {
      value = module.rds.this_rds_cluster_endpoint
    }

    output "rds_instance_endpoints" {
      value = module.rds.this_rds_cluster_instance_endpoints
    }

    output "rds_instance_ids" {
      value = module.rds.this_rds_cluster_instance_ids
    }

## terraform init & run

You can now run

    terraform init

and then run plan or apply with tfvars file like:

    terraform plan -var-file=config/aws-dev.tfvars

or if you had installed terragrunt, just run:

    terragrunt init
    terragrunt plan
