### Prerequisites

Install ansible and terraform (doctl optional)

```shell
$ brew install ansible terraform doctl
```

Set up configuration necessary to use [Terraform](https://www.terraform.io/) with
[DigitalOcean](https://cloud.digitalocean.com/login) (also see official
[tutorial](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)).

```shell
$ export TF_VAR_do_token=<digitalocean personal access token>
$ export TF_VAR_pvt_key=<file path to ssh private key>
$ export TF_VAR_ssh_fingerprint=<md5 fingerprint of public key corresponding to pvt_key>
```

Enable ssh forwarding to `dev.cadizm.com` on Ansible control node

```
$ cat <<EOF >> $HOME/.ssh/config
Host dev.cadizm.com
  ForwardAgent yes
EOF
```

### Provision droplet with domain

```shell
# init one-time operation
$ terraform -chdir=./terraform init
$ terraform -chdir=./terraform plan
$ terraform -chdir=./terraform apply
```

### Install apt packages

```shell
$ ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/install-packages.yml
```

### Setup docker toolchain

```shell
$ ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/setup-docker.yml
```

### Install nginx and add dev.cadizm.com configuration

```shell
$ ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/setup-nginx.yml
```

### Enable ssl using Let's Encrypt

```shell
$ ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/enable-ssl.yml
```

### Add superusers and disable root login

```shell
$ ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/add-superusers.yml
```

### Setup user-specific configurations

```shell
$ ansible-playbook -i ansible/hosts --limit=dev --user=cadizm ansible/playbooks/setup-cadizm.yml
```

### Destroy provisioned resources

```shell
$ terraform -chdir=./terraform show
$ terraform -chdir=./terraform destroy
```
