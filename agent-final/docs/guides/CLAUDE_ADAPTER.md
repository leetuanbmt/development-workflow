# 🔵 Claude Adapter for AI Workflows

**Provider:** Anthropic Claude  
**Version:** 1.0.0  
**Best For:** Complex planning, structured reasoning, multi-step analysis

---

## 📋 Claude-Specific Capabilities

### Strengths

✅ **Extended Thinking:** Solves hard problems with internal reasoning  
✅ **Structured Output:** Consistent formatting, good for parsing  
✅ **Safety & Compliance:** Built-in guardrails  
✅ **Token Efficiency:** Lower input costs for similar models

### Limitations

⚠️ **Context Window:** Only 200K (vs 1M in Antigravity)  
⚠️ **Streaming:** Works, but slower than Gemini  
⚠️ **Cost:** Higher per-token rates

---

## 🔧 Setup Guide

### 1. Get API Key

```bash
# Visit https://console.anthropic.com
# Create an API key
export ANTHROPIC_API_KEY="sk-ant-v0-..."
```

### 2. Install Client

```bash
pip install anthropic
```

### 3. Test Connection

```bash
python3 << 'EOF'
import anthropic

client = anthropic.Anthropic()
message = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "Hello, Claude!"}
    ]
)
print(message.content[0].text)
EOF
```

---

## 💬 Usage Patterns

### Pattern 1: Simple Workflow (One-Shot)

```python
import anthropic

client = anthropic.Anthropic(api_key="sk-ant-...")

# Read workflow
with open("workflows/start-task.md", "r") as f:
    workflow = f.read()

# Add project context
context = """
# Project Context

**Name:** Kansuke Photo
**Stack:** Flutter + Firebase + Drift
**Team:** 3 developers

## Current Task
Add infinite scroll to photo gallery

## Constraints
- Must be performant (60 FPS)
- Handle 1K+ photos
- Work offline
"""

# Send to Claude
message = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=4096,
    messages=[
        {
            "role": "user",
            "content": f"{context}\n\n{workflow}"
        }
    ]
)

print(message.content[0].text)
```

### Pattern 2: Multi-Turn Conversation

```python
from anthropic import Anthropic

client = Anthropic(api_key="sk-ant-...")

messages = []

# Turn 1: Ask for plan
messages.append({
    "role": "user",
    "content": "Create a plan for implementing infinite scroll in Flutter"
})

response = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=2048,
    messages=messages
)

plan = response.content[0].text
messages.append({"role": "assistant", "content": plan})

# Turn 2: Ask for implementation
messages.append({
    "role": "user",
    "content": "Now implement the plan. Generate the complete BLoC code."
})

response = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=4096,
    messages=messages
)

implementation = response.content[0].text
print(implementation)
```

### Pattern 3: With File Context

```python
# Read multiple context files
architecture = open(".agent/memory/ARCHITECTURE.md").read()
code_style = open(".agent/memory/CODE_STYLE.md").read()
glossary = open(".agent/memory/GLOSSARY.md").read()

context_prompt = f"""
# Architecture Reference
{architecture[:2000]}  # First 2000 chars to save tokens

# Code Style
{code_style[:1500]}

# Glossary
{glossary}
"""

message = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=4096,
    messages=[
        {
            "role": "user",
            "content": context_prompt + "\n\n" + workflow
        }
    ]
)
```

---

## 📊 Token Budget per Workflow

| Component             | Tokens   | Notes               |
| --------------------- | -------- | ------------------- |
| Architecture context  | 2K       | First 2K chars only |
| Code style            | 1.5K     | Brief excerpt       |
| Workflow markdown     | 3K       | Full workflow text  |
| Glossary              | 1.5K     | Domain terms        |
| **Input Total**       | ~**8K**  | Leave margin        |
| **Output Generation** | 4K       | Model output        |
| **Safety Margin**     | 5K       | For formatting      |
| **Grand Total**       | ~**17K** | Safe limit          |

**Total Budget: 200K tokens per conversation**

---

## 🚀 Optimization Tips

### 1. Context Compression

```python
def compress_file(filepath, max_chars=2000):
    """Extract first N characters"""
    with open(filepath) as f:
        content = f.read()

    # Take first section
    if len(content) > max_chars:
        return content[:max_chars] + "\n... (truncated)"
    return content

# Usage
architecture_excerpt = compress_file(".agent/memory/ARCHITECTURE.md", 2000)
```

### 2. Selective Context

Instead of including all files, ask Claude what it needs first:

```python
# Step 1: Ask what Claude needs
initial_prompt = """
I need help implementing infinite scroll in Flutter.
My project uses:
- Flutter with BLoC
- Firebase for backend
- Drift for local caching

What additional context would help you most?
(Architecture, Code samples with line numbers, Specific error logs, etc.)
"""

response = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=512,
    messages=[{"role": "user", "content": initial_prompt}]
)

# Claude will ask for specific context
print(response.content[0].text)
```

### 3. Use Line References

Instead of copying entire files, use line references:

```python
prompt = """
I've encountered a performance issue in src/presentation/screens/gallery/gallery_bloc.dart

Lines 45-50 currently fetch all photos at once:
```

// gallery_bloc.dart (lines 45-50)
List<Photo> \_allPhotos = [];
void \_loadPhotos() {
\_allPhotos = repository.getAllPhotos(); // ⚠️ Out of memory for 1K+ photos
}

```

Help me implement pagination here.
"""
```

---

## 🔄 Workflow Patterns for Claude

### Pattern: Plan → Code → Review Flow

```
User: "I need infinite scroll in Flutter"
     ↓
Claude: "Here's the plan:
  1. Create PhotoBloc with pagination logic
  2. Update PhotoWidget to detect scroll
  3. Add tests for boundary cases"
     ↓
User: "Proceed with step 1"
     ↓
Claude: Generates complete BLoC code
     ↓
User: "Review and check for issues"
     ↓
Claude: Audits code for performance, null safety, testing
```

### Pattern: Decomposition

When task is too large:

```
User: "Refactor the entire codebase to clean architecture"
     ↓
Claude: "Too broad. Let's break it down:
  Phase 1: Extract domain layer (2-3 hours)
  Phase 2: Extract data layer (3-4 hours)
  Phase 3: Extract presentation layer (3-4 hours)

  Shall we start with Phase 1?"
     ↓
User: "Yes, phase 1"
     ↓
Claude: Creates detailed Phase 1 plan
```

---

## 🛡️ Error Handling

```python
import anthropic

def call_claude_with_retry(prompt, max_retries=3):
    client = anthropic.Anthropic()

    for attempt in range(max_retries):
        try:
            message = client.messages.create(
                model="claude-3-opus-20250219",
                max_tokens=4096,
                messages=[{"role": "user", "content": prompt}]
            )
            return message.content[0].text

        except anthropic.APIError as e:
            if "overloaded" in str(e).lower():
                print(f"⚠️ Overloaded, waiting... (attempt {attempt+1}/{max_retries})")
                time.sleep(2 ** attempt)
            else:
                raise

    raise Exception("Max retries exceeded")
```

---

## 📝 Workflow Adaptations

### Workflow: /start-task (5K tokens avg)

**For Claude:**

1. Reduced max_iterations (2 instead of 3)
2. Removed verbose examples
3. Added plan-first instruction
4. Compressed context sections

### Workflow: /implement-feature (6K tokens avg)

**For Claude:**

1. Ask for architecture plan first (1K tokens output)
2. Then request code generation (3K tokens output)
3. Finally request tests (2K tokens output)
   - Total: Spread across 3 exchanges vs 1 large output

### Workflow: /audit (4K tokens avg)

**For Claude:**

1. Works great for audits (makes decisions systematically)
2. Can be longer since purely analysis
3. Use for: Code review, security audit, performance analysis

---

## 🔗 Integration with Framework

To use Claude in your project:

```bash
# 1. Copy Claude adapter to project
cp agent-final/docs/adapters/CLAUDE_ADAPTER.md project-docs/

# 2. Set API key
export ANTHROPIC_API_KEY="sk-ant-..."

# 3. Use converter to adapt your workflows
python3 scripts/ai-provider-converter.py \
  --from antigravity \
  --to claude \
  --project-name "My App"

# 4. Follow Claude-specific instructions in converted workflows
```

---

## 📚 Examples

### Example 1: Code Generation Task

See [claude-example-code-gen.md](./claude-examples/code-gen.md)

### Example 2: Architecture Review

See [claude-example-arch-review.md](./claude-examples/arch-review.md)

### Example 3: Test Generation

See [claude-example-test-gen.md](./claude-examples/test-gen.md)
