#!/bin/bash
# Script to reset Nomad on all servers
ansible-playbook -i inventory/hosts.yml reset-nomad.yml --ask-become-pass

