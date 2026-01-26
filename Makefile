.PHONY: all init-gemini init-antigravity

# Default target
all: init-gemini init-antigravity

init-gemini:
	@echo "Initializing Gemini CLI..."
	@cd .. && ./development-workflow/scripts/sync.sh gemini

init-antigravity:
	@echo "Initializing Google Antigravity..."
	@cd .. && ./development-workflow/scripts/sync.sh antigravity
