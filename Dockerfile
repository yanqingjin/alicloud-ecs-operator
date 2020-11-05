#Download terraform cli
FROM busybox AS busybox
WORKDIR /root
RUN wget https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip \
    && unzip /root/terraform_0.13.4_linux_amd64.zip
RUN ls -lt /root/

FROM quay.io/operator-framework/ansible-operator:v1.1.0

#Copy terraform cli to operator image
COPY --from=busybox /root/terraform /usr/bin/terraform

COPY requirements.yml ${HOME}/requirements.yml
RUN ansible-galaxy collection install -r ${HOME}/requirements.yml \
 && chmod -R ug+rwx ${HOME}/.ansible

#Initialize terraform provider plugins.
COPY provider.tf ${HOME}/terraform/provider.tf
USER root
RUN cd ${HOME}/terraform \
    && terraform providers mirror ~/.terraform.d/plugins
    
COPY watches.yaml ${HOME}/watches.yaml
COPY roles/ ${HOME}/roles/
COPY playbooks/ ${HOME}/playbooks/
