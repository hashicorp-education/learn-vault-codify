# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#---------------------
# Create policies
#---------------------
# Create fpe-client policy in the root namespace
resource "vault_policy" "fpe_client_policy" {
  name   = "fpe-client"
  policy = file("policies/fpe-client-policy.hcl")
}

# Create admin policy in the root namespace
resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("policies/admin-policy.hcl")
}

# Create admin policy in the finance namespace
resource "vault_policy" "admin_policy_finance" {
  namespace = vault_namespace.finance.path
  name      = "admins"
  policy    = file("policies/admin-policy.hcl")
}

# Create admin policy in the engineering namespace
resource "vault_policy" "admin_policy_engineering" {
  namespace = vault_namespace.engineering.path
  name      = "admins"
  policy    = file("policies/admin-policy.hcl")
}

# Create admin policy in the education namespace
resource "vault_policy" "admin_policy_education" {
  namespace = vault_namespace.education.path
  name      = "admins"
  policy    = file("policies/admin-policy.hcl")
}

# Create admin policy in the 'education/training' namespace
resource "vault_policy" "admin_policy_training" {
  namespace = vault_namespace.training.path_fq
  name      = "admins"
  policy    = file("policies/admin-policy.hcl")
}

# Create admin policy in the 'education/training/vault_cloud' namespace
resource "vault_policy" "admin_policy_vault_cloud" {
  namespace = vault_namespace.vault_cloud.path_fq
  name      = "admins"
  policy    = file("policies/admin-policy.hcl")
}

# Create admin policy in the 'education/training/boundary' namespace
resource "vault_policy" "admin_policy_boundary" {
  namespace = vault_namespace.boundary.path_fq
  name      = "admins"
  policy    = file("policies/admin-policy.hcl")
}
