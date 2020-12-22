# Toso Arch Linux
Meus scripts e configurações para a instalação de uma versão customizada do Arch

## Pre-instalação

Esse script de instalação faz algumas suposições:
* A instalação supõe que o PC esteja conectado na rede por cabo. Se estiver no wireless, tem que usar a ferramenta `iwclt` para logar na rede (porém eu não testei)
* Supõe que o sistema será instalado no modo UEFI
* Também supõe que o seu disco já esteja formatado em um esquema com uma partição para o EFI, uma para o sistema e opcionalmente uma para swap

## Instalação

Bootar uma .iso do Arch e executar:

```
pacman -Sy && pacman -S git
git clone http://github.com/gitoso/toso-arch-linux
cd toso-arch-install
./install.sh
```

Aí é só responder as perguntas do script

## Detalhes da instalação

* Bootloader: GRUB
* Sistema de Arquivos: 