VENV = venv
PYTHON = $(VENV)/bin/python
PIP = $(VENV)/bin/pip
SCRIPT = script.py
REQUIREMENTS = requirements.txt

GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m

help:
	@echo "$(GREEN)Comandos disponíveis:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

venv:
	@echo "$(GREEN)Criando ambiente virtual...$(NC)"
	@python3 -m venv $(VENV)
	@echo "$(GREEN)Ambiente virtual criado!$(NC)"

install: venv
	@echo "$(GREEN)Instalando dependências...$(NC)"
	@$(PIP) install --upgrade pip
	@$(PIP) install -r $(REQUIREMENTS)
	@echo "$(GREEN)Dependências instaladas!$(NC)"

run:
	@echo "$(GREEN)Executando...$(NC)"
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(YELLOW)Ambiente virtual não encontrado. Criando...$(NC)"; \
		$(MAKE) install; \
	fi
	@$(PYTHON) $(SCRIPT)

clean:
	@echo "$(GREEN)Limpando arquivos...$(NC)"
	@rm -rf $(VENV)
	@rm -rf __pycache__
	@rm -rf .pytest_cache
	@rm -f *.pyc
	@echo "$(GREEN)Limpeza concluída!$(NC)"

#clean-data:
#	@echo "$(GREEN)Removendo arquivos de dados...$(NC)"
#	@echo "$(GREEN)Arquivos de dados removidos!$(NC)"

test:
	@echo "$(GREEN)Testando dependências...$(NC)"
	@if [ ! -d "$(VENV)" ]; then \
		echo "$(YELLOW)Ambiente virtual não encontrado. Execute 'make install' primeiro.$(NC)"; \
		exit 1; \
	fi
	@$(PYTHON) -c "import requests, bs4, pandas, openpyxl; print('$(GREEN)✓ Todas as dependências estão instaladas$(NC)')"

setup: install
	@echo "$(GREEN)Setup completo!$(NC)"

.PHONY: help install run clean venv test
