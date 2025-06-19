set shell := ["bash", "-c"]
set positional-arguments
set dotenv-load
set working-directory := "enterprise"

default: all
all: instructions
prep: version start
rest: deploy status test
clean-all: clean

[group('enterprise')]
@instructions:
   echo ">> running $0"
   echo "1. run 'just prep'"
   echo "2. export the VAULT_CACERT variable"
   echo "3. run 'just rest'"

[group('enterprise')]
@version:
   echo ">> running $0"
   vault version
   terraform version
   docker version

[group('enterprise')]
clean: stop
   echo ">> running $0"
   rm -rf .terraform .terraform.lock.hcl terraform.tfstate tf.plan terraform.tfstate.backup

[group('enterprise')]
@deploy:
   echo ">> running $0"
   -docker run --detach --name learn-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=root-user-password -p 5432:5432 --rm postgres
   sleep 5
   terraform apply -auto-approve

[group('enterprise')]
@status:
   echo ">> running $0"
   vault status

[group('enterprise')]
@start: clean
   echo ">> running $0"
   terraform init
   nohup $(brew --prefix vault-enterprise)/bin/vault server -dev -dev-root-token-id root  -dev-tls > vault.log 2>&1 &
   echo "go into vault.log and find the vaule for VAULT_CACERT and export it"
[group('enterprise')]
@test:
   echo ">> running $0"
   cat terraform.tfstate | grep data_json_wo

[group('enterprise')]
@stop:
   echo ">> running $0"
   -docker stop $(docker ps -f name=learn-postgres -q)
   -pkill vault # ignore if vault is not running