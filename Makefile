all:
	@echo Targets
	@cat Makefile | grep ':' | grep -v 'all:' | awk -F ':' '{print " ", $$1}'

droplet:
	terraform -chdir=./terraform apply

setup: install-packages setup-docker add-superusers setup-cadizm setup-nginx enable-ssl

install-packages: droplet
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/install-packages.yml

setup-docker: install-packages
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/setup-docker.yml

add-superusers: setup-docker
	ansible-playbook -i ansible/hosts --limit=dev --user=root ansible/playbooks/add-superusers.yml

setup-cadizm: add-superusers
	ansible-playbook -i ansible/hosts --limit=dev --user=cadizm ansible/playbooks/setup-cadizm.yml

setup-nginx:  setup-cadizm
	ansible-playbook -i ansible/hosts --limit=dev --user=cadizm ansible/playbooks/setup-nginx.yml

enable-ssl: setup-nginx
	ansible-playbook -i ansible/hosts --limit=dev --user=cadizm ansible/playbooks/enable-ssl.yml
