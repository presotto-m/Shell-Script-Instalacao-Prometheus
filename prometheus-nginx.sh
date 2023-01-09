# Atualizar pacotes, para isso basta estar executando os comandos abaixo;
sudo apt update -y
sudo apt upgrade -y
# Criar diretórios de configuração e dados do Prometheus, execute os comandos a seguir;
sudo mkdir /var/lib/prometheus
sudo mkdir -p /etc/prometheus/rules /etc/prometheus/rules.d /etc/prometheus/files_sd
# Após criar os diretórios, agora vamos baixar e instalar o servidor Prometheus
sudo curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
# Após finalizar o download, use o seguinte comando para extrair o arquivo;
sudo tar xvf prometheus*.tar.gz
# Agora vamos navegar até o diretório e copiar o conteúdo binário do Prometheus para o diretório do sistema /usr/loca/bin/;
cd prometheus-2.41.0.linux-amd64
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
# Configurar o arquivo de serviço do Prometheus, para administrar o serviço Prometheus por meio do systemd, você deve primeiro criar e abrir o arquivo de serviço Prometheus;
echo "[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries \\
  --web.listen-address=0.0.0.0:9090 \\
  --web.external-url=

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/prometheus.service
# Salve e saia o arquivo, Em seguida, reinicie o daemon systemd para aplicar as alterações;
sudo systemctl daemon-reload
# Agora você pode gerenciar os serviços do Prometheus com os seguintes comandos;
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Limpando instalação
rm -rf -d prometheus-2.41.0.linux-amd64
rm -f prometheus-2.41.0.linux-amd64.tar.gz

# Vamos intalar e configurar o Nginx como um proxy reverso, você pode usar e se comunicar com o servidor Prometheus diretamente pela porta, mas não é seguro ou prático para o servidor. Em seguida, você precisa configurar um proxy reverso para o servidor Prometheus para que o servidor não precise se comunicar diretamente com os usuários.
# Instale o servidor da web Nginx com o seguinte comando;
sudo apt install nginx -y
# Configure o servidor Nginx, após a instalação use o seguinte comando para criar um arquivo de configuração de host virtual Nginx;

echo "
server {
    listen 80;
    server_name  10.0.2.15;
    location / {
        proxy_pass           http://localhost:9090/;
    }
}
" > /etc/nginx/conf.d/prometheus.conf

# Agora reinicie e verifique se os serviços Nginx está sendo executado corretamente usando os seguintes comandos; 
sudo systemctl restart nginx

