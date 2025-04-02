#!/bin/bash
# Script to clean up all installations
ansible-playbook -i inventory/hosts.yml cleanup-all.yml --ask-become-pass

