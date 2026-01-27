.PHONY: all sync init-gemini init-antigravity

# Default target
all: sync

sync:
	@echo "🔄 Syncing AI Environment..."
	@bash scripts/sync.sh

init-gemini:
	@echo "Initializing Gemini CLI..."
	@bash scripts/sync.sh gemini

init-antigravity:
	@echo "Initializing Google Antigravity..."
	@bash scripts/sync.sh antigravity
