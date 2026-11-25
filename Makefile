.PHONY: prepare deploy monitoring edit-secrets view-secrets tls-challenge

prepare:
	ansible-galaxy install -r requirements.yml
	ansible-playbook -i inventory.ini playbook.yml --tags prepare --ask-vault-pass

deploy:
	ansible-playbook -i inventory.ini playbook.yml --tags deploy --ask-vault-pass

monitoring:
	ansible-galaxy install -r requirements.yml
	ansible-playbook -i inventory.ini playbook.yml --tags monitoring --ask-vault-pass

tls-challenge:
	ansible-playbook -i inventory.ini playbook.yml --tags tls-challenge --ask-vault-pass

edit-secrets:
	ansible-vault edit group_vars/webservers/vault.yml

view-secrets:
	ansible-vault view group_vars/webservers/vault.yml