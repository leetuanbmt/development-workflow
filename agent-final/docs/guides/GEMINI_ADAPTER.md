# 🟠 Gemini Adapter for AI Workflows

**Provider:** Google Gemini (via CLI)  
**Version:** 1.0.0  
**Best For:** High-throughput tasks, batch processing, large projects

---

## 📋 Gemini-Specific Capabilities

### Strengths

✅ **Huge Context:** 1M tokens (like Antigravity)  
✅ **Streaming:** Native streaming for real-time output  
✅ **Batch Mode:** Process multiple workflows simultaneously  
✅ **Free Tier:** Available within Google Cloud free quota

### Limitations

⚠️ **CLI-Based:** Less IDE integration  
⚠️ **Setup Complexity:** Requires gcloud CLI  
⚠️ **Stability:** Still evolving / new features

---

## 🔧 Setup Guide

### 1. Install Gemini CLI

```bash
# Check if already installed
which gemini

# If not, install from https://ai.google.dev/gemini-cli
# On macOS:
brew tap google/cloud-sdk google-cloud-sdk
brew install google-cloud-sdk

# Then enable Gemini CLI
gcloud components install gemini-cli
```

### 2. Authenticate

```bash
# Method 1: gcloud authentication (recommended)
gcloud auth application-default login
gcloud auth application-default set-quota-project PROJECT_ID

# Method 2: Direct API key (alternative)
export GOOGLE_GENAI_API_KEY="your-api-key"
```

### 3. Verify Installation

```bash
gemini --version
echo "Hello, Gemini" | gemini
```

---

## 💬 Usage Patterns

### Pattern 1: Simple CLI Usage

```bash
# Read workflow and send to Gemini
cat workflows/start-task.md | gemini

# Or direct file input
gemini < workflows/start-task.md

# With output file
gemini < workflows/start-task.md > output.md
```

### Pattern 2: Streaming Output

```bash
# See output in real-time
gemini --stream < workflow.md

# Or piped
cat workflow.md | gemini --stream | tee output.md
```

### Pattern 3: Batch Processing

```bash
# Process multiple workflows
for workflow in workflows/*.md; do
    echo "Processing: $workflow"
    gemini < "$workflow" > "outputs/$(basename $workflow)"
done

# Or use Gemini batch mode (if available)
gemini --batch-file workflows.txt --output-dir outputs/
```

### Pattern 4: With Context Files

```bash
# Combine multiple files into single prompt
(
  echo "# Project Context"
  cat .agent/memory/ARCHITECTURE.md
  echo ""
  echo "# Workflow"
  cat workflows/implement-feature.md
) | gemini > output.md
```

### Pattern 5: Python Integration

```python
import subprocess
import os

def call_gemini(prompt, stream=False):
    """Call Gemini CLI from Python"""
    cmd = ['gemini']
    if stream:
        cmd.append('--stream')

    result = subprocess.run(
        cmd,
        input=prompt.encode(),
        capture_output=not stream,
        text=not stream
    )

    if stream:
        # Output printed directly
        return None
    else:
        return result.stdout

# Usage
workflow = open("workflows/audit.md").read()
output = call_gemini(workflow)
print(output)
```

---

## 📊 Token Budget (1M tokens!)

| Component         | Max Tokens | Notes                 |
| ----------------- | :--------: | --------------------- |
| Full Architecture |    50K     | No compression needed |
| Full Code Style   |    30K     | No compression needed |
| Full Workflow     |    50K     | No compression needed |
| Context Files     |    100K    | Full project context  |
| Output Generation |    200K    | Large outputs OK      |
| **Total**         | **~430K**  | Still well under 1M   |

**Advantage:** Can include full project context without worrying about token limits!

---

## 🚀 Optimization Tips

### 1. Chain Multiple Workflows

Since Gemini has 1M tokens, you can process workflows together:

```bash
# Process sprint tasks sequentially
cat \
  contexts/project.md \
  workflows/start-task.md \
  workflows/implement-feature.md \
  workflows/review.md \
  | gemini

# Gemini understands the full context flow
```

### 2. Use Streaming for Long Tasks

```bash
# Stream output to avoid waiting for full response
gemini --stream < large-workflow.md | \
  tee -a output.md | \
  head -20  # See first 20 lines while waiting
```

### 3. Batch Similar Contexts

```bash
# Group workflows that share context
echo "# Shared Context
$(cat .agent/memory/ARCHITECTURE.md)

# Task 1: Implement Feature A
$(cat workflows/implement-feature.md)

# Task 2: Test Feature A
$(cat workflows/write-test.md)

# Task 3: Code Review
$(cat workflows/review.md)
" | gemini --stream
```

---

## 🔄 Workflow Patterns for Gemini

### Pattern: One-Shot Large Tasks

```
User: "Implement entire API integration + tests + docs"
     ↓
(Combine 3 workflows + full context in one ~350K token request)
     ↓
Gemini: Generates complete implementation in single response
     ↓
Output: Full feature ready for deployment
```

### Pattern: Streaming for Visibility

```bash
# When running long task, see output in real-time
gemini --stream < full-workflow.md | \
  while IFS= read -r line; do
    echo "[$(date '+%H:%M:%S')] $line"
  done
```

### Pattern: Batch Autonomous Processing

```bash
#!/bin/bash
# Process weekly sprint workflows

for week in week-1 week-2 week-3 week-4; do
  echo "Processing $week..."
  gemini < "workflows/$week/tasks.md" > "outputs/$week-results.md"

  # No waiting between - Gemini can queue requests
  sleep 1
done
```

---

## 🛡️ Error Handling

```python
def call_gemini_safe(prompt, max_retries=3, stream=False):
    """Call Gemini with error handling"""
    import subprocess
    import time

    for attempt in range(max_retries):
        try:
            cmd = ['gemini']
            if stream:
                cmd.append('--stream')

            result = subprocess.run(
                cmd,
                input=prompt.encode(),
                capture_output=not stream,
                text=not stream,
                timeout=300  # 5 minute timeout
            )

            if result.returncode == 0:
                return result.stdout if not stream else None
            else:
                print(f"⚠️ Error: {result.stderr}")
                if "quota" in result.stderr.lower():
                    raise Exception("API quota exceeded")

        except subprocess.TimeoutExpired:
            print(f"⚠️ Timeout (attempt {attempt+1}/{max_retries})")
            time.sleep(2 ** attempt)

        except Exception as e:
            print(f"❌ {e}")
            raise

    raise Exception("Max retries exceeded")
```

---

## 📝 Workflow Adaptations for Gemini

### No Changes Needed!

The beauty of Gemini is that **no workflow adaptation is needed**. Since it has 1M tokens like Antigravity:

- Use workflows as-is
- Include full context
- No compression needed
- Same output format

Just ensure you're using Gemini CLI instead of Antigravity API.

---

## 🔐 Security & Quota

### Free Tier Limits

```
- 60 requests per minute
- 100 requests per day
- 1M tokens max per request
```

### Production Setup

```bash
# Set quotas to track costs
gcloud auth application-default set-quota-project YOUR-PROJECT

# Monitor usage
gcloud alpha ai-platform requests list --limit=10

# Set budget alerts
# See: https://cloud.google.com/billing/docs/how-to/budgets
```

---

## 🔗 Integration with Framework

To use Gemini in your project:

```bash
# 1. Copy Gemini adapter to project
cp agent-final/docs/guides/GEMINI_ADAPTER.md project-docs/

# 2. Set up authentication
gcloud auth application-default login

# 3. Use converter to verify workflows (no major changes)
python3 scripts/ai-provider-converter.py \
  --from antigravity \
  --to gemini \
  --project-name "My App"

# 4. Test a workflow
cat workflows/start-task.md | gemini

# 5. Integrate with build system
# Add to Makefile or CI/CD
```

---

## 📊 Comparison: Gemini vs Antigravity

| Factor               | Gemini       | Antigravity |
| -------------------- | ------------ | ----------- |
| **Max Context**      | 1M           | 1M          |
| **Free Tier**        | Yes (60/min) | No          |
| **Streaming**        | Yes (native) | Via API     |
| **Batch Mode**       | Yes          | No          |
| **IDE Integration**  | No           | Varies      |
| **CLI-First**        | Yes          | No          |
| **Setup Complexity** | Medium       | Low         |

**Verdict:** Gemini is ideal if you:

- Want free or cheap option
- Need streaming output
- Have 1M+ token workflows
- Prefer CLI over IDE

---

## 💡 Advanced Examples

### Example 1: Monitoring with Streaming

```bash
#!/bin/bash

# Process workflow while monitoring output
gemini --stream < workflow.md | while read -r line; do
  # Count tokens (rough estimate: 4 chars = 1 token)
  tokens=$((${#line} / 4))

  echo "[$tokens tokens] $line"

  # Alert if getting too long
  if [ $tokens -gt 200000 ]; then
    echo "⚠️ Warning: Approaching token limit"
  fi
done
```

### Example 2: Combining with CI/CD

```yaml
# GitHub Actions example
name: AI Code Review
on: [pull_request]

jobs:
  gemini-review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Gemini
        run: |
          gcloud auth activate-service-account --key-file=${{ secrets.GCP_SA_KEY }}

      - name: Generate review
        run: |
          (
            echo "# Code Review"
            git diff
            echo ""
            cat .agent/memory/CODE_STYLE.md
          ) | gemini > review.md

      - name: Comment on PR
        uses: actions/github-script@v6
        with:
          script: |
            const fs = require('fs');
            const review = fs.readFileSync('review.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: review
            });
```

---

## 📚 Further Reading

- [Gemini CLI Documentation](https://ai.google.dev/gemini-cli)
- [Google AI Studio](https://aistudio.google.com)
- [GCP Free Tier Info](https://cloud.google.com/free)
