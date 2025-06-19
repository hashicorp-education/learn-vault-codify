# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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

# create a kv v2 secrets engine in the root namespace
resource "vault_mount" "kvv2" {
  path        = "my-kvv2"
  type        = "kv"
  options     = { version = "2" }
}

# Create a kv v2 secrets with the data_json_wo argument
resource "vault_kv_secret_v2" "db_root" {
  mount        = vault_mount.kvv2.path
  name         = "pgx-root"
  data_json_wo = jsonencode(
    {
      password = "root-user-password"
    }
  )
  data_json_wo_version = 1
}

# create an ephemeral vault_kv_secret_v2 resource
ephemeral "vault_kv_secret_v2" "db_secret" {
  mount = vault_mount.kvv2.path
  mount_id = vault_mount.kvv2.id
  name = vault_kv_secret_v2.db_root.name
}

# mount a database secrets engine at the path "postgres"
resource "vault_mount" "db" {
  path = "postgres"
  type = "database"
}

# Get the latest PostgreSQL image
resource "docker_image" "postgres" {
  name = "postgres:latest"
}

# Start a PostgreSQL container
resource "docker_container" "postgres" {
  name  = "learn-postgres"
  image = docker_image.postgres.image_id
  env = ["POSTGRES_USER=postgres", "POSTGRES_PASSWORD=root-user-password"]
  ports {
    internal = 5432
    external = 5432
    }
  rm = true
}

# create a database role for the postgres database with a
# PostgreSQL Configuration option that uses the password_wo
# to set the password
resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.db.path
  name          = docker_container.postgres.name # "learn-postrgres"
  allowed_roles = ["*"]

  postgresql {
    connection_url = "postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable"
    password_authentication = ""
    username = "postgres"
    password_wo = tostring(ephemeral.vault_kv_secret_v2.db_secret.data.password)
    password_wo_version = 1
  }
}