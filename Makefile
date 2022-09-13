all:
	@echo Targets
	@cat Makefile | grep ':' | grep -v 'all:' | awk -F ':' '{print " ", $$1}'

droplet:
	terraform -chdir=./terraform apply

setup: install-packages setup-docker setup-nginx enable-ssl add-superusers setup-cadizm

install-packages: droplet
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/install-packages.yml

setup-docker: install-packages
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/setup-docker.yml

setup-nginx:  install-packages
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/setup-nginx.yml

enable-ssl: setup-nginx
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/enable-ssl.yml

add-superusers: install-packages
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/add-superusers.yml

setup-cadizm: add-superusers
	ansible-playbook -i ansible/hosts --limit=dev --user=cadizm ansible/playbooks/setup-cadizm.yml
