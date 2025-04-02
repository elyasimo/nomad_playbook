#!/bin/bash
# Script to debug Nomad issues
ansible-playbook -i inventory/hosts.yml debug-nomad.yml --ask-become-pass

