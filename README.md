# Script de instalação do Prometheus para Debian 11

**Importante:** este é um trabalho em andamento.

**Ainda mais importante:** Se você realmente planeja usar isso, não se esqueça de editar os arquivos de configuração de acordo com suas necessidades (arquivos de serviço, arquivos de configuração YAML, etc.). Os arquivos de configuração fornecidos aqui são apenas arquivos genéricos.

Este script baixa os arquivos no diretório atual. Você poderia mudar isso.

Quaisquer sugestões e contribuições são bem-vindas.

# Como usar isso?

Se você estiver usando isso para instalar componentes individuais ou o aplicativo completo, é melhor iniciar os scripts do repositório clonado. Se você copiar scripts em qualquer outro lugar, o comportamento dos scripts não é garantido. **Observe que esses scripts adicionarão o Prometheus e outros utilitários ao systemd como serviços e habilitarão o por padrão**.

## Instalação completa

A instalação completa instalará o seguinte:

* Prometheus

Os scripts possuem muitos `sudo`s, então antes de iniciar a instalação completa, faça:

```bash
sudo pwd
```
apenas para ter certeza, `sudo` em scripts não irá interrompê-lo. Depois disso, você pode executar o script como:

```bash
./Prometheus.sh
```
Ou execute o script como um usuário `root`.
