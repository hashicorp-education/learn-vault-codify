# Codify Management of Vault

These provided assets aid in preforming the tasks described in the following tutorials:

- [Codify Management of Vault](https://learn.hashicorp.com/tutorials/vault/codify-mgmt-oss)
- [Codify Management of Vault Enterprise](https://learn.hashicorp.com/tutorials/vault/codify-mgmt-enterprise)

For [Codify Management of Vault Enterprise](https://learn.hashicorp.com/tutorials/vault/codify-mgmt-enterprise) you will need to have a Vault enterprise license set - usually the `VAULT_LICENSE_PATH` or `VAULT_LICENSE` env variables.

## using just file

update the `VAULT_LICENSE_PATH` in the `.env` file to point to your vault enterprise license file.

just start - `terraform init`, start vault enterprise server, instructions to get VAULT_CACERT value

just clean - clean up tf directory

just stop - `pkill vault` and stop docker container

just deploy - run docker container for postgres, terraform apply

just test - verify that the write-only attribute (`data_json_wo`) is a null in tf state
