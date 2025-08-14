# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

#--------------------------------
# Enable userpass auth method
#--------------------------------
resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

# Create a user named, "student"
resource "vault_generic_endpoint" "student" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/student"
  ignore_absent_fields = true

  data_json = <<EOT
{
  "policies": ["fpe-client", "admins"],
  "password": "changeme"
}
EOT
}

#--------------------------------------------------------------------
# Enable approle auth method in the 'education/training' namespace
#--------------------------------------------------------------------
resource "vault_auth_backend" "approle" {
  depends_on = [vault_namespace.training]
  namespace  = vault_namespace.training.path_fq
  type       = "approle"
}

# Create a role named, "test-role"
resource "vault_approle_auth_backend_role" "test-role" {
  depends_on     = [vault_auth_backend.approle]
  backend        = vault_auth_backend.approle.path
  namespace      = vault_namespace.training.path_fq
  role_name      = "test-role"
  token_policies = ["default", "admins"]
}