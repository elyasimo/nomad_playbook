#!/bin/bash
# Script to backup Nomad data and configuration
mkdir -p backups
ansible-playbook -i inventory/hosts.yml backup-nomad.yml --ask-become-pass

