.PHONY: all sync init-gemini init-antigravity sync-workflows sync-skills sync-quick sync-runtime setup-wizard detect-stack score-skills cache-status cache-clear cache-cleanup

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

# ─────────────────────────────────────────────────────────────────────────────
# NEW: Setup & Configuration Utilities
# ─────────────────────────────────────────────────────────────────────────────

setup-wizard:
	@echo "🎉 Starting interactive setup wizard..."
	@bash scripts/setup_interactive.sh --lang=vi

setup-wizard-en:
	@echo "🎉 Starting interactive setup wizard (English)..."
	@bash scripts/setup_interactive.sh --lang=en

setup-non-interactive:
	@echo "⚙️  Non-interactive setup..."
	@bash scripts/setup_interactive.sh --non-interactive

detect-stack:
	@echo "🔍 Detecting tech stack..."
	@bash scripts/detect_stack_with_validation.sh --force

detect-stack-json:
	@echo "🔍 Detecting tech stack (JSON output)..."
	@bash scripts/detect_stack_with_validation.sh --force --json

score-skills:
	@echo "🎯 Skill Confidence Scorer"
	@python3 scripts/skill_confidence_scorer.py --interactive

score-skill:
	@echo "🎯 Scoring skills for task: $(task)"
	@python3 scripts/skill_confidence_scorer.py "$(task)"

# ─────────────────────────────────────────────────────────────────────────────
# Cache Management
# ─────────────────────────────────────────────────────────────────────────────

cache-status:
	@echo "📦 Checking cache status..."
	@bash scripts/cache_manager.sh status

cache-clear:
	@echo "🗑️  Clearing cache..."
	@bash scripts/cache_manager.sh clear --pattern="$(pattern)"

cache-clear-all:
	@echo "🗑️  Clearing ALL cache..."
	@bash scripts/cache_manager.sh clear

cache-invalidate:
	@echo "⏰ Invalidating old cache..."
	@bash scripts/cache_manager.sh invalidate --age="$(age)"

cache-cleanup:
	@echo "🧹 Auto-cleanup cache (invalidate old + size check)..."
	@bash scripts/cache_manager.sh cleanup

# ─────────────────────────────────────────────────────────────────────────────
# Help & Documentation
# ─────────────────────────────────────────────────────────────────────────────

help:
	@echo "📚 Development Workflow - Make Commands"
	@echo ""
	@echo "Core Sync:"
	@echo "  make sync                - Full sync (auto-detect mode)"
	@echo "  make sync-quick          - Fast sync (workflows + skills)"
	@echo "  make sync-workflows      - Sync workflows only"
	@echo "  make sync-skills         - Sync skills only"
	@echo "  make sync-runtime        - Preserve hydrated workflows"
	@echo ""
	@echo "Deployment:"
	@echo "  make deploy              - Deploy to all projects"
	@echo "  make deploy project=app1 - Deploy to specific project"
	@echo ""
	@echo "Setup & Config:"
	@echo "  make setup-wizard        - Interactive wizard (Vietnamese)"
	@echo "  make setup-wizard-en     - Interactive wizard (English)"
	@echo "  make detect-stack        - Detect tech stack"
	@echo "  make score-skills        - Skill selector (interactive)"
	@echo "  make score-skill task=... - Score skills for task"
	@echo ""
	@echo "Cache Management:"
	@echo "  make cache-status        - Show cache contents"
	@echo "  make cache-clear         - Clear cache files"
	@echo "  make cache-cleanup       - Auto-cleanup (invalidate + size)"
	@echo ""
	@echo "Environment Initialization:"
	@echo "  make init-gemini         - Initialize Gemini CLI"
	@echo "  make init-antigravity    - Initialize Antigravity"

