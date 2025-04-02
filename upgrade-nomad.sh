#!/bin/bash
# Script to upgrade Nomad to a new version
# Usage: ./upgrade-nomad.sh [version]
# Example: ./upgrade-nomad.sh 1.9.8

VERSION=${1:-"1.9.7"}

ansible-playbook -i inventory/hosts.yml upgrade-nomad.yml -e "new_nomad_version=$VERSION" --ask-become-pass

