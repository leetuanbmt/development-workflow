# AI Provider Adapter Layer

This document describes how to support multiple AI providers (Claude, Gemini, GitHub Copilot) alongside Google Antigravity.

---

## 🎯 Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                  Workflow Definition                         │
│                  (Provider Agnostic)                         │
└────────────────────────┬────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    ┌────▼────┐    ┌─────▼─────┐   ┌────▼────┐
    │ Claude  │    │  Gemini   │   │Copilot  │
    │Adapter  │    │ Adapter   │   │Adapter  │
    └────┬────┘    └─────┬─────┘   └────┬────┘
         │               │               │
    ┌────▼────────────────┼───────────────┴──────┐
    │    Provider-Specific Implementation        │
    │  (API calls, context management, output)  │
    └──────────────────────────────────────────┘
```

---

## 🔧 Provider Specifications

###Claude (Anthropic)

| Property           | Value                                  |
| ------------------ | -------------------------------------- |
| **Context Window** | 200K tokens                            |
| **API Type**       | REST                                   |
| **Authentication** | API Key (`ANTHROPIC_API_KEY`)          |
| **Best For**       | Complex planning, multi-step reasoning |
| **Requires Plan**  | Yes (structured thinking)              |
| **Output Format**  | Markdown                               |

**Key Features:**

- Extended thinking for complex problems
- Strong at planning before execution
- Good for security/architecture reviews

**Limitations:**

- Smallest context window
- Requires careful token management

---

### Gemini CLI

| Property           | Value                             |
| ------------------ | --------------------------------- |
| **Context Window** | 1M tokens                         |
| **API Type**       | CLI + REST                        |
| **Authentication** | gcloud + API Key                  |
| **Best For**       | High-throughput, batch processing |
| **Requires Plan**  | No                                |
| **Output Format**  | Markdown                          |

**Key Features:**

- Very large context (good for projects with 500+ files)
- Native streaming support
- Batch processing capability

**Limitations:**

- CLI-based (less IDE integration)
- Requires gcloud setup

---

### GitHub Copilot

| Property           | Value                         |
| ------------------ | ----------------------------- |
| **Context Window** | 8K input / 2K output          |
| **API Type**       | IDE-based + REST              |
| **Authentication** | OAuth (GitHub account)        |
| **Best For**       | Code generation, inline fixes |
| **Requires Plan**  | Yes (break into small steps)  |
| **Output Format**  | Code-focused                  |

**Key Features:**

- Deep IDE integration
- Real-time suggestions
- Good for code generation

**Limitations:**

- Tight context limits
- Code-focused (not architecture planning)

---

### Google Antigravity (Original)

| Property           | Value                                   |
| ------------------ | --------------------------------------- |
| **Context Window** | 1M tokens                               |
| **API Type**       | REST                                    |
| **Authentication** | OAuth                                   |
| **Best For**       | Large workflows, unrestricted execution |
| **Requires Plan**  | No                                      |
| **Output Format**  | Markdown                                |

**Key Features:**

- Largest context window
- No artificial constraints
- Full framework optimization

---

## 📋 Choosing a Provider

**Use Claude if:**

- You need structured planning before code
- Project is small-medium (<100 files)
- You can afford API costs
- You want extended thinking

**Use Gemini if:**

- You have large projects (500+ files)
- You want streaming output
- You prefer batch processing workflows
- You want free or low-cost option

**Use GitHub Copilot if:**

- You want IDE integration
- You're doing code generation/fixes
- Your tasks are small (<5K tokens)
- You want real-time suggestions

**Use Antigravity if:**

- You want maximum flexibility
- You have complex, long-running workflows
- You don't want to optimize for token limits

---

## 🔌 Using the Converter

### Installation

```bash
cd agent-final
pip install pyyaml  # Required dependency
```

### Basic Usage

```bash
# Convert all workflows to Claude format
python3 scripts/ai-provider-converter.py \
  --from antigravity \
  --to claude \
  --project-name "My App" \
  --stack flutter

# Convert to Gemini
python3 scripts/ai-provider-converter.py --to gemini

# Convert to GitHub Copilot
python3 scripts/ai-provider-converter.py --to copilot

# List available providers
python3 scripts/ai-provider-converter.py --list-providers
```

### Advanced Options

```bash
# Custom output directory
python3 scripts/ai-provider-converter.py \
  --to claude \
  --output-dir ./my-workflows

# Workflows only (no config)
python3 scripts/ai-provider-converter.py \
  --to claude \
  --workflows-only

# Specify stack for config generation
python3 scripts/ai-provider-converter.py \
  --to gemini \
  --stack nodejs
```

---

## 🚀 Provider-Specific Setup

### Claude Setup

```bash
# 1. Get API key from https://console.anthropic.com
export ANTHROPIC_API_KEY="sk-ant-..."

# 2. Use with curl
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d @request.json

# 3. Or use in Python
import anthropic
client = anthropic.Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
message = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=4096,
    messages=[{"role": "user", "content": prompt}]
)
```

### Gemini Setup

```bash
# 1. Install Gemini CLI (if needed)
# See: https://ai.google.dev/gemini-cli

# 2. Authenticate
gcloud auth application-default login

# 3. Or use API key
export GOOGLE_GENAI_API_KEY="your-api-key"

# 4. Use Gemini CLI
gemini < workflow.md

# 5. Or Python SDK
import google.generativeai as genai
genai.configure(api_key=os.environ.get("GOOGLE_GENAI_API_KEY"))
model = genai.GenerativeModel("gemini-2.0-flash")
response = model.generate_content(prompt)
```

### GitHub Copilot Setup

```bash
# 1. Install extension
# VS Code: "GitHub Copilot" (official)
# JetBrains: "GitHub Copilot" plugin
# Vim: coc-copilot or copilot.vim

# 2. Authenticate through IDE
# VS Code: Command Palette > "GitHub Copilot: Sign in"

# 3. Use in editor
# Copilot Chat: Cmd+K (VS Code) or Alt+\ (JetBrains)
# Inline suggestions: Typing code triggers suggestions
```

---

## 🔄 Workflow Adaptation Examples

### Example 1: Convert /start-task to Claude

**Original (Antigravity):**

```markdown
---
description: "Start new feature..."
trigger: /start-task
constraints:
  max_iterations: 3
  timeout_minutes: 60
---

# 🚀 Start Task

... (long detailed workflow)
```

**Converted (Claude):**

```markdown
---
description: "Start new feature..."
trigger: /start-task
requires_plan_before_execution: true
constraints:
  max_iterations: 2 # Reduced for smaller context
  timeout_minutes: 45
---

## 🔵 Claude-Specific Instructions

(With planning guidance, context compression tips)

# 🚀 Start Task

... (compressed workflow content)
```

### Example 2: Convert to GitHub Copilot

**Copilot focuses only on the "Code Generation" parts:**

```markdown
# Start Task - Copilot Code Focus

## Quick Reference

- **Ask Copilot for:** Code generation, file structure, imports
- **Ask Claude/Gemini for:** Architecture planning, task breakdown

## When to Use Copilot

1. ✅ Generate user story template
2. ✅ Create file structure scaffold
3. ✅ Generate test skeleton

## When to Use Claude

1. 🔵 Plan feature architecture
2. 🔵 Break down requirements
3. 🔵 Review definition of ready
```

---

## 🛠️ Implementing Provider Adapters

### For a new provider (e.g., OpenAI o1):

1. **Add Provider Config**

```python
# In ai-provider-converter.py
PROVIDERS['o1'] = ProviderConfig(
    name='OpenAI o1',
    max_tokens=32_000,
    context_window=128_000,
    api_format='rest',
    ...
)
```

2. **Create Adapter Class**

```python
class O1Adapter:
    def convert_workflow(self, workflow):
        # Custom conversion logic for o1
        # e.g., optimize for structured reasoning
        pass
```

3. **Register in Converter**

```python
class WorkflowConverter:
    ADAPTERS = {
        'claude': ClaudeAdapter(),
        'o1': O1Adapter(),
        ...
    }
```

---

## 📊 Context Window Management

| Provider    | Win/Loss vs Antigravity | Strategy                                           |
| ----------- | :---------------------: | -------------------------------------------------- |
| Claude      |   -800K (very tight)    | Split workflows, compress content, reference files |
| Gemini      |       Same (~1M)        | Full workflows, batch processing                   |
| Copilot     |     -992K (extreme)     | Break into micro-tasks, focus on code              |
| Antigravity |        Baseline         | No optimization needed                             |

---

## 🔐 Multi-Provider Security

**Each provider has different security requirements:**

| Provider    |   Auth Method    | Secret Management                          |
| ----------- | :--------------: | ------------------------------------------ |
| Claude      |     API Key      | Use `ANTHROPIC_API_KEY` environment        |
| Gemini      | gcloud + API Key | Use `gcloud auth` + `GOOGLE_GENAI_API_KEY` |
| Copilot     |   GitHub OAuth   | Use GitHub CLI (`gh auth`)                 |
| Antigravity |      OAuth       | Standard Google OAuth flow                 |

**Best Practice:**

```bash
# Never commit secrets
echo "ANTHROPIC_API_KEY=..." >> .env.local
echo ".env.local" >> .gitignore

# Load before running
export $(cat .env.local)
python3 scripts/ai-provider-converter.py --to claude
```

---

## ✅ Validation Checklist

After converting to a new provider:

- [ ] No sensitive data in workflows (API keys, tokens)
- [ ] All {{PLACEHOLDERS}} are replaced with actual values
- [ ] Constraints are adjusted for target context window
- [ ] Skill references are valid
- [ ] Output format matches provider expectations
- [ ] Provider-specific instructions are clear
- [ ] Configuration files generated successfully
- [ ] Team members have API keys set up

---

## 📚 Further Reading

- [Claude Documentation](https://docs.anthropic.com/)
- [Gemini CLI Guide](https://ai.google.dev/gemini-cli)
- [GitHub Copilot Docs](https://github.com/features/copilot)
- [Antigravity Framework](./QUICK_REFERENCE.md)
