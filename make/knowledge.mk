# ==========================================================
# Knowledge
# ==========================================================

.PHONY: knowledge knowledge-download knowledge-index knowledge-update

KNOWLEDGE_SCRIPT_DIR := $(CURDIR)/scripts/knowledge

knowledge: knowledge-update

knowledge-download:
	@$(KNOWLEDGE_SCRIPT_DIR)/download.sh "$(PWD)"

knowledge-index:
	@$(KNOWLEDGE_SCRIPT_DIR)/index.sh "$(PWD)"

knowledge-update:
	@$(KNOWLEDGE_SCRIPT_DIR)/update.sh "$(PWD)"