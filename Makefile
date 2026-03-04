.PHONY: all sync init-gemini init-antigravity sync-workflows sync-skills sync-quick sync-runtime

# Default target
all: sync

# Full sync (smart mode)
sync:
	@echo "🔄 Syncing AI Environment..."
	@bash scripts/sync.sh

# Runtime sync (preserve hydrated workflows)
sync-runtime:
	@echo "🔥 Syncing in runtime mode..."
	@bash scripts/sync.sh --runtime

# Quick sync: Only workflows and skills (no backup, no validation)
sync-quick:
	@echo "⚡ Quick sync (workflows + skills only)..."
	@bash scripts/sync_quick.sh

# Sync workflows only (from core/ to .agent/)
sync-workflows:
	@echo "📋 Syncing workflows only..."
	@bash scripts/sync_quick.sh --workflows-only

# Sync skills only (from core/ to .agent/)
sync-skills:
	@echo "🧠 Syncing skills only..."
	@bash scripts/sync_quick.sh --skills-only

# Deploy to other projects
deploy:
	@echo "🚀 Deploying to all sibling projects..."
	@bash scripts/deploy_to_projects.sh

deploy-to:
	@echo "🚀 Deploying to specific project: $(project)"
	@bash scripts/deploy_to_projects.sh $(project)

init-gemini:
	@echo "Initializing Gemini CLI..."
	@bash scripts/sync.sh gemini

init-antigravity:
	@echo "Initializing Google Antigravity..."
	@bash scripts/sync.sh antigravity

