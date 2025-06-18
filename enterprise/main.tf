# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#------------------------------------------------------------------------------
# The best practice is to use remote state file and encrypt it since your
# state files may contains sensitive data (secrets).
#------------------------------------------------------------------------------
# terraform {
#       backend "s3" {
#             bucket = "remote-terraform-state-dev"
#             encrypt = true
#             key = "terraform.tfstate"
#             region = "us-east-1"
#       }
# }

#-----------------------------------------------------------------------------------
# To configure Transform secrets engine, you need vault provider v2.12.0 or later
#-----------------------------------------------------------------------------------
terraform {
  required_providers {
    vault = "~> 3.7.0"
  }
}

#------------------------------------------------------------------------------
# To leverage more than one namespace, define a vault provider per namespace
#------------------------------------------------------------------------------

provider "vault" {}

#------------------------------------------------------------------------------
# Create namespaces: finance, and engineering
#------------------------------------------------------------------------------
resource "vault_namespace" "finance" {
  path = "finance"
}

resource "vault_namespace" "engineering" {
  path = "engineering"
}

#---------------------------------------------------------------
# Create nested namespaces
#   education has childnamespace, 'training'
#       training has childnamespace, 'secure'
#           secure has childnamespace, 'vault_cloud' and 'boundary'
#---------------------------------------------------------------
resource "vault_namespace" "education" {
  path = "education"
}


# Create a childnamespace, 'training' under 'education'
resource "vault_namespace" "training" {
  namespace = vault_namespace.education.path
  path = "training"
}

# Create a childnamespace, 'vault_cloud' and 'boundary' under 'education/training'
resource "vault_namespace" "vault_cloud" {
  namespace = vault_namespace.training.path_fq
  path = "vault_cloud"
}

# Create 'education/training/boundary' namespace
resource "vault_namespace" "boundary" {
  namespace = vault_namespace.training.path_fq
  path = "boundary"
}