#!/bin/bash
# Script to check Nomad cluster status
ansible-playbook -i inventory/hosts.yml check-cluster.yml --ask-become-pass

