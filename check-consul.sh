#!/bin/bash
# Script to check Consul cluster status
ansible-playbook -i inventory/hosts.yml check-consul.yml --ask-become-pass
