#!/bin/bash
# Run the Ansible playbook
ansible-playbook -i inventory/hosts.yml site.yml --ask-become-pass

