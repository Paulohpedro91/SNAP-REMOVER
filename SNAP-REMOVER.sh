#!/bin/bash

# =================================================================
# NOME: SNAP-REMOVER
# DESCRIÇÃO: Script interativo para remoção completa do Snapd
# =================================================================

# Cores
GREEN='\e[1;32m'
RED='\e[1;31m'
BLUE='\e[1;34m'
NC='\e[0m'

# Função de Barra de Progresso
print_progress() {
    local width=40
    local filled=$(( ($1 * width) / 100 ))
    printf "\r${BLUE}[%-$(echo $width)s] %d%%${NC} - %s" "$(printf "%${filled}s" | tr ' ' '#')" "$1" "$2"
}

# Função de Pausa para retornar ao menu
pause_and_back() {
    echo -e "\n\n${BLUE}Pressione [Enter] para voltar ao menu...${NC}"
    read
    clear
}

remove_snap_with_progress() {
    echo -e "\n"
    
    # Etapa 1
    print_progress 15 "Removendo pacotes Snap (isso pode demorar)..."
    for snap in $(snap list 2>/dev/null | awk 'NR>1 {print $1}'); do
        sudo snap remove --purge "$snap" &>/dev/null
    done
    
    # Etapa 2
    print_progress 30 "Desmontando unidades e mounts do Snap..."
    for mount in $(mount | grep snap | awk '{print $3}'); do
        sudo umount -lf "$mount" &>/dev/null
    done
    
    # Etapa 3
    print_progress 50 "Parando serviços snapd.service..."
    sudo systemctl disable --now snapd.service snapd.socket snapd.seeded.service &>/dev/null
    
    # Etapa 4
    print_progress 70 "Removendo pacote snapd via APT..."
    sudo apt purge -y snapd gnome-software-plugin-snap &>/dev/null
    
    # Etapa 5
    print_progress 85 "Limpando diretórios /var/snap e /snap..."
    sudo rm -rf ~/snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd /snap &>/dev/null
    
    # Etapa 6
    print_progress 95 "Configurando bloqueio de reinstalação..."
    cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref > /dev/null
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
    sudo apt update &>/dev/null
    
    print_progress 100 "Concluído!"
    echo -e "\n${GREEN}O sistema agora está livre do Snap!${NC}"
    pause_and_back
}

check_status() {
    echo -e "\n--- Verificação de Integridade ---"
    if ! command -v snap &>/dev/null; then 
        echo -e "${GREEN}Status: Snap removido e bloqueado com sucesso.${NC}"
    else 
        echo -e "${RED}Status: O Snap ainda está instalado ou vestígios foram encontrados.${NC}"
        snap list 2>/dev/null
    fi
    pause_and_back
}

# --- LOOP DO MENU ---
clear
while true; do
    echo -e "${BLUE}========================================"
    echo -e "           SNAP-REMOVER v1.0"
    echo -e "========================================${NC}"
    echo -e "Escolha uma opção abaixo:"
    
    options=("Remover Snap Completamente" "Verificar Exclusão" "Sair")
    
    select opt in "${options[@]}"; do
        case $opt in
            "Remover Snap Completamente")
                echo -e "${RED}AVISO: Firefox e Chromium (se instalados via Snap) serão removidos!${NC}"
                read -p "Deseja continuar? (s/n): " confirm
                if [[ $confirm == [sS] ]]; then
                    remove_snap_with_progress
                else
                    clear
                fi
                break 
                ;;
            "Verificar Exclusão")
                check_status
                break
                ;;
            "Sair")
                echo -e "${GREEN}Saindo do SNAP-REMOVER. Até logo!${NC}"
                exit 0
                ;;
            *) 
                echo -e "${RED}Opção inválida. Tente novamente.${NC}"
                ;;
        esac
    done
done
