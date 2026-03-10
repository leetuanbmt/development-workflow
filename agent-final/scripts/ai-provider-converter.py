#!/usr/bin/env python3
"""
AI Provider Converter Tool
Convert Antigravity workflows to Claude, Gemini CLI, or GitHub Copilot

Usage:
    python3 ai-provider-converter.py --from antigravity --to claude [--output-dir ./]
    python3 ai-provider-converter.py --from antigravity --to gemini --stack flutter
    python3 ai-provider-converter.py --help
"""

import os
import json
import yaml
import argparse
import sys
from pathlib import Path
from typing import Dict, List, Any
from dataclasses import dataclass


@dataclass
class ProviderConfig:
    """Configuration for different AI providers"""
    name: str
    max_tokens: int
    context_window: int
    api_format: str  # 'rest', 'grpc', 'cli'
    auth_type: str  # 'api-key', 'oauth', 'cli'
    supports_streaming: bool
    supports_functions: bool
    requires_plan: bool
    output_format: str  # 'markdown', 'json', 'mixed'
    instruction_style: str  # 'detailed', 'concise', 'structured'


# Provider Configurations
PROVIDERS = {
    'antigravity': ProviderConfig(
        name='Google Antigravity',
        max_tokens=1_000_000,
        context_window=1_000_000,
        api_format='rest',
        auth_type='api-key',
        supports_streaming=True,
        supports_functions=True,
        requires_plan=False,
        output_format='markdown',
        instruction_style='detailed'
    ),
    'claude': ProviderConfig(
        name='Claude (Anthropic)',
        max_tokens=200_000,
        context_window=200_000,
        api_format='rest',
        auth_type='api-key',
        supports_streaming=True,
        supports_functions=True,
        requires_plan=True,
        output_format='markdown',
        instruction_style='structured'
    ),
    'gemini': ProviderConfig(
        name='Gemini CLI',
        max_tokens=1_000_000,
        context_window=1_000_000,
        api_format='cli',
        auth_type='cli',
        supports_streaming=True,
        supports_functions=True,
        requires_plan=False,
        output_format='markdown',
        instruction_style='structured'
    ),
    'copilot': ProviderConfig(
        name='GitHub Copilot',
        max_tokens=8_000,
        context_window=32_000,
        api_format='rest',
        auth_type='oauth',
        supports_streaming=True,
        supports_functions=False,
        requires_plan=True,
        output_format='markdown',
        instruction_style='concise'
    )
}


class WorkflowParser:
    """Parse Antigravity workflow files"""

    @staticmethod
    def parse_workflow(file_path: str) -> Dict[str, Any]:
        """Parse workflow markdown file with YAML frontmatter"""
        with open(file_path, 'r') as f:
            content = f.read()

        # Extract YAML frontmatter
        if content.startswith('---'):
            parts = content.split('---', 2)
            if len(parts) >= 3:
                meta = yaml.safe_load(parts[1])
                body = parts[2].strip()
            else:
                meta = {}
                body = content
        else:
            meta = {}
            body = content

        return {
            'metadata': meta,
            'body': body,
            'file_path': file_path
        }

    @staticmethod
    def parse_skill(file_path: str) -> Dict[str, Any]:
        """Parse skill markdown file"""
        return WorkflowParser.parse_workflow(file_path)

    @staticmethod
    def discover_workflows(root_dir: str) -> List[str]:
        """Find all workflow files"""
        workflows = []
        workflow_dirs = [
            Path(root_dir) / 'workflows' / 'core',
            Path(root_dir) / 'workflows' / 'ops',
            Path(root_dir) / 'workflows' / 'tech',
            Path(root_dir) / 'core' / 'workflows'
        ]

        for workflow_dir in workflow_dirs:
            if workflow_dir.exists():
                workflows.extend(workflow_dir.glob('*.md'))

        return [str(w) for w in workflows]

    @staticmethod
    def discover_skills(root_dir: str) -> List[str]:
        """Find all skill files"""
        skills = []
        skill_dirs = [
            Path(root_dir) / 'skills',
            Path(root_dir) / 'core' / 'skills'
        ]

        for skill_dir in skill_dirs:
            if skill_dir.exists():
                skills.extend(skill_dir.glob('*/SKILL.md'))

        return [str(s) for s in skills]


class WorkflowConverter:
    """Convert workflows between providers"""

    def __init__(self, from_provider: str, to_provider: str):
        self.from_config = PROVIDERS[from_provider]
        self.to_config = PROVIDERS[to_provider]
        self.from_provider = from_provider
        self.to_provider = to_provider

    def convert_workflow(self, workflow: Dict[str, Any]) -> Dict[str, Any]:
        """Convert workflow from one provider to another"""
        meta = workflow['metadata'].copy()
        body = workflow['body']

        # Plan required adjustments based on context window
        if self.to_config.context_window < self.from_config.context_window:
            body = self._compress_content(body)

        # Add provider-specific instructions
        instructions = self._add_provider_instructions()

        # Adjust constraint limits
        meta = self._adjust_constraints(meta)

        # Convert to provider-specific format
        converted = {
            'metadata': meta,
            'body': body,
            'provider_instructions': instructions,
            'converted_from': self.from_provider,
            'converted_to': self.to_provider
        }

        return converted

    def _compress_content(self, body: str) -> str:
        """Compress content for smaller context windows"""
        lines = body.split('\n')
        compressed = []
        prev_type = None

        for line in lines:
            # Skip empty lines in examples
            if not line.strip() and prev_type == 'example':
                continue

            # Condense verbose sections
            if '**Objective:**' in line:
                prev_type = 'objective'
                compressed.append(line)
            elif '## 🔄 Execution Flow' in line:
                prev_type = 'flow'
                compressed.append(line)
            else:
                compressed.append(line)
                prev_type = 'other'

        return '\n'.join(compressed)

    def _adjust_constraints(self, meta: Dict[str, Any]) -> Dict[str, Any]:
        """Adjust workflow constraints for target provider"""
        if 'constraints' in meta:
            constraints = meta['constraints']

            # Shorter timeouts for GitHub Copilot
            if self.to_provider == 'copilot' and 'timeout_minutes' in constraints:
                constraints['timeout_minutes'] = min(
                    15, constraints.get('timeout_minutes', 30))

            # Add plan requirement for Claude
            if self.to_provider == 'claude' and self.to_config.requires_plan:
                meta['requires_plan_before_execution'] = True

        return meta

    def _add_provider_instructions(self) -> str:
        """Generate provider-specific instructions"""
        instructions = ""

        if self.to_provider == 'claude':
            instructions = """
## 🔵 Claude-Specific Instructions

**Context Window:** 200K tokens (manage context carefully)
**Recommendation:** Always provide a brief execution plan before implementing

### How to Use
1. Copy-paste this workflow into Claude conversation
2. Provide project context (files, error logs, requirements)
3. Claude will generate a plan first, then implementation

### Token Optimization
- Use `/summary` command to compress context if needed
- Refer to `.agent/memory/ARCHITECTURE.md` for architecture patterns
- Ask Claude to use `{...}` notation for file excerpts instead of full content
"""
        elif self.to_provider == 'gemini':
            instructions = """
## 🟠 Gemini CLI-Specific Instructions

**Context Window:** 1M tokens (good for large projects)
**Recommendation:** Suitable for high-throughput tasks

### How to Use
1. Activate Gemini CLI with AI provider
2. Configure Gemini API key in environment
3. Run: `gemini -f workflow.md < project_context.txt`

### Streaming Support
- Gemini supports streaming output (see live progress)
- Use `--stream` flag for real-time output
"""
        elif self.to_provider == 'copilot':
            instructions = """
## ⚫ GitHub Copilot-Specific Instructions

**Context Window:** 8K input / 2K output (tight constraints)
**Recommendation:** Break into smaller tasks, focus on code implementation

### How to Use
1. Install GitHub Copilot extension in VS Code/JetBrains
2. Copy essential workflow sections only (not full markdown)
3. Ask Copilot focused questions based on workflow steps

### Best Practices
- Keep prompts under 500 tokens
- Provide concrete examples before asking for implementation
- Use line references (e.g., "Line 45-50 in controller.ts")
- Focus on: code generation, debugging, refactoring
"""

        return instructions

    def to_dict(self) -> Dict[str, Any]:
        """Get converter configuration as dict"""
        return {
            'from': self.from_provider,
            'from_config': self.from_config.__dict__,
            'to': self.to_provider,
            'to_config': self.to_config.__dict__
        }


class ProviderAdapterFactory:
    """Generate provider-specific configuration files"""

    @staticmethod
    def generate_claude_config(project_name: str, stack: str) -> str:
        """Generate Claude-optimized configuration"""
        config = f"""
# Claude AI Provider Configuration

## Project: {project_name}
## Stack: {stack}

### API Configuration
- **Provider:** Anthropic Claude
- **Model:** claude-3-opus-20250219 (recommended for complex tasks)
- **Max Tokens:** 200,000
- **Timeout:** 5 minutes

### Context Management
- **Memory Files:** Reference .agent/memory/ (not included in conversation)
- **Workflow Size:** Compress to ~3-5K tokens max per request
- **Context Passing:** Provide file excerpts (first 50 lines) then reference file paths

### Authentication
```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

### Usage Example
```bash
curl -X POST https://api.anthropic.com/v1/messages \\
  -H "x-api-key: $ANTHROPIC_API_KEY" \\
  -H "anthropic-version: 2023-06-01" \\
  -H "content-type: application/json" \\
  -d '{{
    "model": "claude-3-opus-20250219",
    "max_tokens": 4096,
    "messages": [{{
      "role": "user",
      "content": "Your workflow request here..."
    }}]
  }}'
```

### Workflow Adaptation Rules
1. Always request a "Plan" section first before implementation
2. Include definition of done checklist in each request
3. Break complex workflows into 2-3 sub-tasks
4. Use function calling for structured outputs

### Token Budget per Request
- Input context: 150K tokens max
- Output generation: 50K tokens
- Safety margin: Reserve 5K for formatting
"""
        return config.strip()

    @staticmethod
    def generate_gemini_config(project_name: str, stack: str) -> str:
        """Generate Gemini CLI-optimized configuration"""
        config = f"""
# Gemini CLI Provider Configuration

## Project: {project_name}
## Stack: {stack}

### CLI Configuration
- **Provider:** Google Gemini
- **Model:** gemini-2.0-flash (recommended)
- **Max Tokens:** 1,000,000
- **Mode:** Batch + Streaming

### Setup
```bash
# Install Gemini CLI (if not already installed)
# See: https://ai.google.dev/gemini-cli

# Configure authentication
gcloud auth application-default login
export GOOGLE_GENAI_API_KEY="your-api-key-here"  # Alternative: API key auth
```

### Usage Examples

#### Interactive Mode
```bash
gemini < workflow.md
# Or piped with context
cat project_context.txt workflow.md | gemini
```

#### File-based Mode
```bash
gemini -f workflow.md -f project_context.txt -o output.md
```

#### Streaming Mode
```bash
gemini --stream workflow.md | tee output.md
```

#### Batch Processing (Multiple Workflows)
```bash
for file in workflows/*.md; do
  gemini -f "$file" -o "outputs/$(basename $file)"
done
```

### Workflow Adaptation Rules
1. Gemini supports larger contexts - include full architecture files
2. Use streaming for long-running tasks
3. Leverage batch mode for multiple workflows
4. Reference memory files directly (Gemini can handle it)

### Performance Tips
- Use `--cached` flag for repeated context
- Enable streaming for immediate feedback
- Batch similar workflows together
"""
        return config.strip()

    @staticmethod
    def generate_copilot_config(project_name: str, stack: str) -> str:
        """Generate GitHub Copilot-optimized configuration"""
        config = f"""
# GitHub Copilot Provider Configuration

## Project: {project_name}
## Stack: {stack}

### IDE Setup
- **VS Code:** Install "GitHub Copilot" extension
- **JetBrains:** Install "GitHub Copilot" plugin
- **Vim/Neovim:** Use coc-copilot or copilot.vim

### Authentication
```bash
# VS Code: Sign in through extension UI
# Or command line:
gh copilot setup
gh auth login
```

### Recommended Models
- **Default:** GPT-4 (if available)
- **Fallback:** GPT-3.5-turbo
- **Context Window:** 8K input / 2K output per request

### Workflow Adaptation for Copilot

**⚠️ Important:** Copilot has tight context limits. Adapt workflows like this:

#### Option A: Code-Focused Questions
```
// In VS Code comment or chat:
// Copilot: Generate DTO class for this JSON response:
// [JSON excerpt]
```

#### Option B: Using Copilot Chat (Extended Context)
```
@codebase Implement the feature described in .agent/memory/PROJECT.md
focusing on the API integration layer shown in ARCHITECTURE.md.

Specifically: [2-3 line user request]
```

#### Option C: Line References (Most Effective)
```
// At line 45 in src/models/user.dart:
// Copilot: Add validation method here, handle null safely
```

### Workflow Segments to Use Copilot For
- ✅ Code generation from specs
- ✅ Bug fixes with error logs
- ✅ Refactoring patterns
- ✅ Test case generation
- ✅ Documentation from code

### Workflow Segments to Use Claude/Gemini For
- ✅ Architecture design
- ✅ Complex feature planning
- ✅ Multi-file refactoring
- ✅ High-level task breakdown
- ✅ Project-wide audits

### Using Copilot Chat Effectively
```
# Share project context first
@workspace I'm building a {stack} app. Here's the architecture:
[Brief architecture summary]

# Then ask specific code questions
@codebase Generate a new API integration for [endpoint] following patterns in:
- src/data/repositories/
- src/domain/entities/
```

### Token Budget per Request
- Input: 5K tokens max
- Output: 2K tokens
- Total: Keep well under 8K to avoid truncation
"""
        return config.strip()

    @staticmethod
    def generate_provider_switch_script() -> str:
        """Generate shell script to switch between providers"""
        script = """#!/bin/bash

# AI Provider Switcher
# Switch between Antigravity, Claude, Gemini, and GitHub Copilot

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CURRENT_PROVIDER_FILE="$SCRIPT_DIR/.ai-provider"

# Colors
GREEN='\\033[0;32m'
BLUE='\\033[0;34m'
RED='\\033[0;31m'
NC='\\033[0m'

show_usage() {
    echo "Usage: $0 [provider] [options]"
    echo ""
    echo "Providers:"
    echo "  antigravity     Google Antigravity AI"
    echo "  claude          Claude (Anthropic)"
    echo "  gemini          Gemini CLI (Google)"
    echo "  copilot         GitHub Copilot"
    echo ""
    echo "Options:"
    echo "  --stack STACK   Specify framework (flutter, nodejs, python, generic)"
    echo "  --list          Show current provider"
    echo "  --help          Show this message"
    echo ""
    echo "Examples:"
    echo "  $0 claude --stack flutter"
    echo "  $0 gemini"
    echo "  $0 --list"
}

# Parse arguments
PROVIDER="${1:-}"
STACK="generic"

while [[ $# -gt 1 ]]; do
    case "${2}" in
        --stack)
            STACK="${3}"
            shift 2
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

case "${PROVIDER}" in
    antigravity)
        echo -e "${BLUE}🔵 Switching to: Google Antigravity${NC}"
        echo "antigravity" > "$CURRENT_PROVIDER_FILE"
        echo "  - Max Context: 1M tokens"
        echo "  - API Format: REST"
        echo "  - Best for: High-throughput, large projects"
        ;;
    
    claude)
        echo -e "${BLUE}🟣 Switching to: Claude (Anthropic)${NC}"
        echo "claude" > "$CURRENT_PROVIDER_FILE"
        echo "  - Max Context: 200K tokens"
        echo "  - API Format: REST"
        echo "  - Best for: Complex planning, multi-step tasks"
        echo ""
        echo "  Setup: export ANTHROPIC_API_KEY='your-key'"
        ;;
    
    gemini)
        echo -e "${BLUE}🟠 Switching to: Gemini CLI${NC}"
        echo "gemini" > "$CURRENT_PROVIDER_FILE"
        echo "  - Max Context: 1M tokens"
        echo "  - API Format: CLI"
        echo "  - Best for: Batch processing, streaming output"
        echo ""
        echo "  Setup: gcloud auth application-default login"
        ;;
    
    copilot)
        echo -e "${BLUE}⚫ Switching to: GitHub Copilot${NC}"
        echo "copilot" > "$CURRENT_PROVIDER_FILE"
        echo "  - Max Context: 8K tokens"
        echo "  - API Format: IDE-based"
        echo "  - Best for: Code generation in editor, quick fixes"
        echo ""
        echo "  Setup: GitHub Copilot VS Code extension installed?"
        ;;
    
    --list)
        if [ -f "$CURRENT_PROVIDER_FILE" ]; then
            CURRENT=$(cat "$CURRENT_PROVIDER_FILE")
            echo "Current AI Provider: ${GREEN}$CURRENT${NC}"
        else
            echo "No provider currently set. Choose one:"
            echo "  $0 antigravity"
            echo "  $0 claude"
            echo "  $0 gemini"
            echo "  $0 copilot"
        fi
        ;;
    
    *)
        show_usage
        exit 1
        ;;
esac

echo -e "${GREEN}✅ Provider switched successfully${NC}"
"""
        return script.strip()


class WorkflowOutputGenerator:
    """Generate output files for target provider"""

    def __init__(self, output_dir: str, provider: str):
        self.output_dir = Path(output_dir)
        self.provider = provider
        self.output_dir.mkdir(parents=True, exist_ok=True)

    def save_workflow(self, workflow: Dict[str, Any], original_filename: str):
        """Save converted workflow"""
        meta = workflow['metadata']
        body = workflow['body']
        instructions = workflow['provider_instructions']

        # Generate output content
        output = f"""---
# Auto-converted from Antigravity to {self.provider}
converted_from: antigravity
converted_to: {self.provider}
"""
        for key, value in meta.items():
            if key != 'requires_plan_before_execution':
                output += f"{key}: {json.dumps(value) if not isinstance(value, str) else repr(value)}\n"

        output += "---\n\n"
        output += instructions + "\n\n"
        output += body

        # Save file
        output_path = self.output_dir / original_filename
        with open(output_path, 'w') as f:
            f.write(output)

        print(f"  ✅ {original_filename}")

    def save_config(self, config_type: str, project_name: str, stack: str):
        """Save provider configuration"""
        if config_type == 'claude':
            config = ProviderAdapterFactory.generate_claude_config(
                project_name, stack)
        elif config_type == 'gemini':
            config = ProviderAdapterFactory.generate_gemini_config(
                project_name, stack)
        elif config_type == 'copilot':
            config = ProviderAdapterFactory.generate_copilot_config(
                project_name, stack)
        else:
            return

        config_file = self.output_dir / f"{config_type}-config.md"
        with open(config_file, 'w') as f:
            f.write(config)

        print(f"  ✅ {config_file.name}")

    def save_provider_switch_script(self):
        """Save shell script for switching providers"""
        script = ProviderAdapterFactory.generate_provider_switch_script()
        script_file = self.output_dir.parent / "switch-provider.sh"
        with open(script_file, 'w') as f:
            f.write(script)

        # Make executable
        os.chmod(script_file, 0o755)
        print(f"  ✅ switch-provider.sh (executable)")


def main():
    parser = argparse.ArgumentParser(
        description='Convert AI workflows between providers (Antigravity → Claude/Gemini/Copilot)'
    )
    parser.add_argument(
        '--from',
        dest='from_provider',
        default='antigravity',
        choices=list(PROVIDERS.keys()),
        help='Source provider (default: antigravity)'
    )
    parser.add_argument(
        '--to',
        dest='to_provider',
        required=True,
        choices=['claude', 'gemini', 'copilot'],
        help='Target provider'
    )
    parser.add_argument(
        '--project-root',
        default='.',
        help='Project root directory (default: current)'
    )
    parser.add_argument(
        '--output-dir',
        default=None,
        help='Output directory (default: .converted-workflows/{provider})'
    )
    parser.add_argument(
        '--stack',
        default='generic',
        choices=['flutter', 'nodejs', 'python', 'generic'],
        help='Technology stack (default: generic)'
    )
    parser.add_argument(
        '--project-name',
        default='My Project',
        help='Project name for generated configs'
    )
    parser.add_argument(
        '--workflows-only',
        action='store_true',
        help='Convert workflows only (no config files)'
    )
    parser.add_argument(
        '--list-providers',
        action='store_true',
        help='List all providers and their specs'
    )

    args = parser.parse_args()

    # List providers if requested
    if args.list_providers:
        print("\n🔵 Available AI Providers:\n")
        for name, config in PROVIDERS.items():
            print(
                f"  {name:15} | Context: {config.context_window:>7,} | Max: {config.max_tokens:>7,} tokens")
        print()
        return

    # Validate source provider
    if args.from_provider not in PROVIDERS:
        print(f"❌ Unknown provider: {args.from_provider}")
        sys.exit(1)

    # Set output directory
    output_dir = args.output_dir or f".converted-workflows/{args.to_provider}"

    print(f"\n🔄 Converting Workflows")
    print(f"   From: {args.from_provider.upper()}")
    print(f"   To:   {args.to_provider.upper()}")
    print(f"   Root: {args.project_root}")
    print(f"   Output: {output_dir}\n")

    # Create converter
    converter = WorkflowConverter(args.from_provider, args.to_provider)
    print(f"📊 Converter Config:")
    print(
        f"   Context Window: {converter.from_config.context_window:,} → {converter.to_config.context_window:,} tokens")
    print(f"   Max Output: {converter.to_config.max_tokens:,} tokens")
    print()

    # Discover and convert workflows
    parser_obj = WorkflowParser()
    workflow_files = parser_obj.discover_workflows(args.project_root)

    print(f"📝 Converting {len(workflow_files)} Workflows:\n")

    output_gen = WorkflowOutputGenerator(output_dir, args.to_provider)

    for workflow_file in workflow_files:
        try:
            workflow = parser_obj.parse_workflow(workflow_file)
            converted = converter.convert_workflow(workflow)
            output_gen.save_workflow(converted, Path(workflow_file).name)
        except Exception as e:
            print(f"  ❌ {Path(workflow_file).name}: {e}")

    # Generate configuration files
    if not args.workflows_only:
        print(f"\n⚙️  Generating Provider Configs:\n")
        output_gen.save_config(args.to_provider, args.project_name, args.stack)
        output_gen.save_provider_switch_script()

    print(f"\n✅ Conversion Complete!")
    print(f"   Output directory: {output_dir}")
    print(f"   Next: cd {output_dir} && review the converted workflows")
    print()


if __name__ == '__main__':
    main()
