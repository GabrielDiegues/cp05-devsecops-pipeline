#!/bin/bash
# CP04 - bootstrap da EC2 (Amazon Linux 2023).
# Cole este conteudo em "Detalhes avancados > Dados do usuario" ao lancar a instancia.
# A EC2 ja sobe instalando o Docker e rodando o container do portal.

set -xe

# 1. Instala e habilita o Docker
dnf install -y docker
systemctl enable --now docker

# 2. Permite ao ec2-user usar docker sem sudo (efetivo apos novo login SSH)
usermod -aG docker ec2-user

# 3. Aguarda o daemon subir e puxa/roda a imagem publica do Docker Hub
until docker info >/dev/null 2>&1; do sleep 2; done
docker pull gabrieldiegues/cp04-arcanjo:cp04
docker run -d --restart unless-stopped --name portal-arcanjo \
  -p 80:80 gabrieldiegues/cp04-arcanjo:cp04
