#!/bin/bash

# Atualizar pacotes, para isso basta estar executando os comandos abaixo;
Sudo apt update -y
Sudo apt upgrade -y

# Criar diretórios de configuração e dados do Prometheus, execute os comandos a seguir;
sudo mkdir /var/lib/prometheus
sudo mkdir -p /etc/prometheus/rules /etc/prometheus/rules.d /etc/prometheus/files_sd

# Após criar os diretórios, agora vamos baixar e instalar o servidor Prometheus
sudo curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi –

# Após finalizar o download, use o seguinte comando para extrair o arquivo;
sudo tar xvf prometheus*.tar.gz

# Agora vamos navegar até o diretório e copiar o conteúdo binário do Prometheus para o diretório do sistema /usr/loca/bin/;
cd prometheus*/
sudo mv prometheus promtool /usr/local/bin/

# Mova os seguintes arquivos de configuração e diretórios para o diretório /etc/prometheus;
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo mv consoles/ console_libraries/ /etc/prometheus/

# Configurando usuário e grupo do Prometheus, vamos criar um usuário e um grupo Prometheus dedicados com os seguintes comandos;
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Em seguida use o seguinte comando para configurar as permissões e a propriedade do diretório; 
sudo chown -R prometheus:prometheus /etc/prometheus
sudo chmod -R 775 /etc/prometheus/
sudo chown -R prometheus:prometheus /var/lib/prometheus/

# Agora você pode gerenciar os serviços do Prometheus com os seguintes comandos;
sudo systemctl start prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus

