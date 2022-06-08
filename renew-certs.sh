#!/bin/bash

set -e

ansible-playbook -i ~/pai-deploy/kubespray/inventory/pai/hosts.yml -e "ansible_python_interpreter=/usr/bin/python3" --become --become-user root renew-master-certs.yaml

ansible-playbook -i ~/pai-deploy/kubespray/inventory/pai/hosts.yml -e "ansible_python_interpreter=/usr/bin/python3" --become --become-user root renew-master-token.yaml

token=`cat token`

sed "s/{{ token }}/${token}/g" renew-worker-certs.yaml.template > renew-worker-certs.yaml

ansible-playbook -i ~/pai-deploy/kubespray/inventory/pai/hosts.yml -e "ansible_python_interpreter=/usr/bin/python3" --limit '!kube-master' --become --become-user root renew-worker-certs.yaml
