Ter uma máquina que tenha os seguintes requisitos:

* Ansible
* Terraform
* aws-cli
* jq

Acessar o diretório terraform-scripts

Executar os comandos abaixo:

```
terraform init
terraform apply -auto-approve
```

Após isso, acessar o diretório ansible e executar o script bash:

```
sh setup-swarm.sh
```
Testar acessando o NGINX configurado no IP público.
