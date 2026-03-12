# 🚀 SNAP-REMOVER

O **SNAP-REMOVER** é um utilitário interativo em Bash projetado para remover completamente o ecossistema Snap de distribuições baseadas no Ubuntu. Diferente de uma remoção simples, este script garante que todos os resíduos sejam eliminados e que o sistema seja bloqueado contra reinstalações indesejadas.

---

## ✨ Funcionalidades

* **Menu Interativo:** Interface simples no terminal para facilitar a navegação.
* **Barra de Progresso:** Feedback visual em tempo real (0% a 100%) para cada etapa do processo.
* **Limpeza Profunda:**
    * Remove pacotes Snap com a flag `--purge`.
    * Desmonta pontos de montagem (`mount points`) ativos automaticamente.
    * Elimina diretórios residuais (`/var/snap`, `/var/lib/snapd`, etc).
* **Bloqueio Permanente:** Cria uma regra de prioridade no APT para impedir que o `snapd` seja reinstalado como dependência.

---

## 🛠️ Como usar

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/seu-usuario/SNAP-REMOVER.git](https://github.com/seu-usuario/SNAP-REMOVER.git)
    cd SNAP-REMOVER
    ```

2.  **Dê permissão de execução:**
    ```bash
    chmod +x SNAP-REMOVER.sh
    ```

3.  **Execute o script:**
    ```bash
    sudo ./SNAP-REMOVER.sh
    ```

---

## ⚠️ Avisos Importantes

> [!CAUTION]
> No Ubuntu moderno, navegadores como **Firefox** e **Chromium** são distribuídos via Snap. Ao executar este script, eles serão removidos do sistema. Certifique-se de ter um navegador alternativo ou o link para o PPA oficial antes de prosseguir.

* **Backup:** Recomendamos criar um ponto de restauração antes de alterações profundas no sistema.
* **Compatibilidade:** Testado prioritariamente em Ubuntu 22.04 LTS e 24.04 LTS.

---

## 📄 Licença

Este projeto está sob a licença **MIT**. Sinta-se livre para usar, modificar e distribuir.

---
*Desenvolvido para tornar o Ubuntu mais leve e sob o seu controle.*
