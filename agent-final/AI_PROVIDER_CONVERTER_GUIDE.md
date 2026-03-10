# 🔄 AI Provider Converter - Quick Start Guide

**Convert your AI workflows from Google Antigravity to Claude, Gemini CLI, or GitHub Copilot**

---

## ⚡ 2-Minute Quick Start

### 1. Install Dependencies

```bash
cd agent-final
pip install pyyaml
```

### 2. Convert Workflows

```bash
# Convert to Claude
python3 scripts/ai-provider-converter.py --to claude

# Or Gemini
python3 scripts/ai-provider-converter.py --to gemini

# Or GitHub Copilot
python3 scripts/ai-provider-converter.py --to copilot
```

### 3. Find Output

```bash
# Converted workflows are in:
.converted-workflows/claude/      # For Claude
.converted-workflows/gemini/      # For Gemini
.converted-workflows/copilot/     # For Copilot
```

### 4. Read Provider-Specific Guide

- **Claude:** Read [docs/guides/CLAUDE_ADAPTER.md](./docs/guides/CLAUDE_ADAPTER.md)
- **Gemini:** Read [docs/guides/GEMINI_ADAPTER.md](./docs/guides/GEMINI_ADAPTER.md)
- **Copilot:** Read [docs/guides/COPILOT_ADAPTER.md](./docs/guides/COPILOT_ADAPTER.md)

**Done!** Start using the converted workflows.

---

## 📖 Full Guide

###Choosing Your AI Provider

| Need                          |     Best Provider     | Why                   |
| ----------------------------- | :-------------------: | --------------------- |
| **Big projects (500+ files)** | Gemini or Antigravity | 1M token context      |
| **Structured planning**       |        Claude         | Extended thinking     |
| **IDE coding assistance**     |    GitHub Copilot     | Real-time suggestions |
| **Cost-conscious**            |   Gemini Free Tier    | 60 req/min free       |
| **Maximum flexibility**       |      Antigravity      | 1M tokens, no limits  |

---

## 🛠️ Detailed Usage

### Convert with Custom Output Directory

```bash
python3 scripts/ai-provider-converter.py \
  --to claude \
  --output-dir ./converted-workflows
```

### Workflows Only (No Configs)

```bash
python3 scripts/ai-provider-converter.py \
  --to claude \
  --workflows-only
```

### Specify Project Info

```bash
python3 scripts/ai-provider-converter.py \
  --to gemini \
  --project-name "Photo Gallery App" \
  --stack flutter
```

### List All Providers and Specs

```bash
python3 scripts/ai-provider-converter.py --list-providers
```

**Output:**

```
🔵 Available AI Providers:

  antigravity     | Context:  1,000,000 | Max: 1,000,000 tokens
  claude          | Context:    200,000 | Max:   200,000 tokens
  gemini          | Context:  1,000,000 | Max: 1,000,000 tokens
  copilot         | Context:     32,000 | Max:     8,000 tokens
```

---

## 🔐 Setting Up Each Provider

### Claude (Anthropic)

```bash
# 1. Get free API key from https://console.anthropic.com/
# 2. Set environment variable
export ANTHROPIC_API_KEY="sk-ant-v0-..."

# 3. Python example
import anthropic
client = anthropic.Anthropic()
message = client.messages.create(
    model="claude-3-opus-20250219",
    max_tokens=4096,
    messages=[{"role": "user", "content": "Your workflow here..."}]
)
```

### Gemini CLI

```bash
# 1. Install (if needed)
gcloud components install gemini-cli

# 2. Authenticate
gcloud auth application-default login

# 3. Use directly
cat workflows/start-task.md | gemini

# Or with streaming
gemini --stream < workflows/implement-feature.md
```

### GitHub Copilot

```bash
# 1. Install extension in VS Code or JetBrains
# 2. Sign in with GitHub
# 3. Open Copilot Chat (Cmd+K in VS Code)
# 4. Use adapted workflows for code generation
```

---

## 📊 Provider Comparison

### Context Windows (Most Important!)

```
Antigravity: ████████████████████ 1,000,000 tokens (No limits!)
Gemini:      ████████████████████   1,000,000 tokens (Free 60/min)
Claude:      ██████               200,000 tokens (Requires API key)
Copilot:     █                      8,000 tokens (IDE-based)
```

### Use Cases

```
Large Projects (500+ files):
  ✅ Gemini (free tier, 1M context)
  ✅ Antigravity (max flexibility)
  ❌ Claude (too many tokens)
  ❌ Copilot (doesn't support)

Complex Planning:
  ✅ Claude (structured thinking)
  ✅ Antigravity (no constraints)
  ✅ Gemini (1M tokens for deep analysis)
  ❌ Copilot (code-focused only)

Fast IDE-based Coding:
  ✅ GitHub Copilot (real-time suggestions)
  ✅ Copilot Chat (multi-turn in editor)
  ✅ Antigravity (if integrated with IDE)
  ❌ Claude (API-only)
  ❌ Gemini (CLI-only)
```

---

## 🚀 Real-World Examples

### Example 1: Solo Developer, Small Budget

**Setup:**

```bash
# Use free Gemini tier
gcloud auth application-default login
python3 scripts/ai-provider-converter.py --to gemini

# Use GitHub Copilot for coding (if available)
# (VS Code extension is free for open source)
```

**Workflow:**

```
1. Use Gemini for planning large features
2. Use Copilot for code generation
3. Use Copilot Chat for debugging
4. Use Gemini for code review
```

### Example 2: Team with Budget (Claude)

**Setup:**

```bash
export ANTHROPIC_API_KEY="sk-ant-..."
python3 scripts/ai-provider-converter.py --to claude
```

**Workflow:**

```
1. Use Claude for architecture planning
2. Use Copilot for IDE assistance
3. Use Claude for code reviews
4. Use Copilot Chat for quick fixes
```

### Example 3: Large Project (Gemini + Copilot)

**Setup:**

```bash
# Both free/cheap
gcloud auth application-default login  # Gemini
# Install Copilot extension
python3 scripts/ai-provider-converter.py --to gemini
```

**Workflow:**

```
1. Use Gemini for batch processing entire workflows
2. Use Copilot for IDE-based code generation
3. Use Gemini streaming to watch progress
4. Use Copilot Chat for line-by-line fixes
```

---

## 🎯 Migration Checklist

When switching from Antigravity to another provider:

- [ ] Run converter: `python3 scripts/ai-provider-converter.py --to <provider>`
- [ ] Read provider adapter guide (CLAUDE_ADAPTER.md, etc.)
- [ ] Set up authentication (API key, gcloud, GitHub, etc.)
- [ ] Update team documentation (which provider for which task)
- [ ] Test 1-2 workflows with new provider
- [ ] Adjust your workflow processes (token limits, streaming, etc.)
- [ ] Train team on new provider's best practices
- [ ] Monitor costs/usage for first week

---

## 📋 Troubleshooting

### Problem: "ModuleNotFoundError: No module named 'yaml'"

**Solution:**

```bash
pip install pyyaml
```

### Problem: "No workflows found"

**Solution:**

```bash
# Converter looks for workflows in:
# - ./workflows/core/
# - ./workflows/ops/
# - ./workflows/tech/
# - ./core/workflows/

# Make sure you have workflows in one of these directories
ls -la workflows/core/
```

### Problem: "Output directory not created"

**Solution:**

```bash
# Converter auto-creates output directory
# If not found, try:
python3 scripts/ai-provider-converter.py \
  --to claude \
  --output-dir ./my-converted-workflows
```

### Problem: Claude: "Context window exceeded"

**Solution:**

1. Use line references instead of full files
2. Break task into smaller chunks
3. Re-read CLAUDE_ADAPTER.md for optimization tips

### Problem: Gemini: "Quota exceeded"

**Solution:**

```bash
# Check free tier limits: 60 req/min
# Wait a minute or get paid API key
gcloud auth application-default set-quota-project YOUR_PROJECT
```

### Problem: Copilot: "No suggestions appearing"

**Solution:**

1. Install "GitHub Copilot Chat" extension (separate)
2. Authenticate via GitHub
3. Wait 30 seconds (extension loads)
4. Try typing `// ` to trigger inline suggestions

---

## 🔄 Switching Providers (After Initial Setup)

If you want to try different providers later:

```bash
# Try Claude
python3 scripts/ai-provider-converter.py --to claude

# Then Gemini
python3 scripts/ai-provider-converter.py --to gemini

# Then Copilot
python3 scripts/ai-provider-converter.py --to copilot

# All outputs in separate directories
```

No conflicts - each provider has its own directory.

---

## 📊 What Gets Converted?

### Converted (Auto-Adapted):

✅ Workflow markdown files  
✅ YAML frontmatter adjusted for provider  
✅ Provider-specific instructions added  
✅ Context window constraints adjusted  
✅ Configuration files generated

### NOT Converted (Still Antigravity):

❌ Skill files (reused as-is)  
❌ Memory files (.agent/memory/)  
❌ Rules files

**Note:** Skills and memory files work across all providers since they're provider-agnostic.

---

## 🎓 Learning Resources

### Official Provider Docs

- [Claude Documentation](https://docs.anthropic.com/)
- [Gemini CLI Guide](https://ai.google.dev/gemini-cli)
- [GitHub Copilot Docs](https://github.com/features/copilot)
- [Antigravity Framework](./QUICK_REFERENCE.md)

### Framework Guides

- [AI Provider Adapter Layer](./docs/guides/AI_PROVIDER_ADAPTER.md) - Deep dive
- [Claude Adapter](./docs/guides/CLAUDE_ADAPTER.md) - Claude-specific
- [Gemini Adapter](./docs/guides/GEMINI_ADAPTER.md) - Gemini-specific
- [Copilot Adapter](./docs/guides/COPILOT_ADAPTER.md) - Copilot-specific

### Tutorial Videos

- Claude API Integration (on Anthropic YouTube)
- Gemini CLI Walkthrough (on Google Developers)
- Copilot Tips & Tricks (on GitHub)

---

## 💡 Tips & Best Practices

### Tip 1: Start with One Provider

Don't try to migrate everything at once. Choose one provider and master it first.

```bash
# Start with Claude (most structured)
python3 scripts/ai-provider-converter.py --to claude
```

### Tip 2: Keep Antigravity as Fallback

Don't delete original Antigravity workflows. Keep them as reference.

```bash
git commit -m "chore: generate converted workflows for Claude/Gemini/Copilot"
# Original workflows still in ./workflows/
```

### Tip 3: Test Before Full Migration

Test 1-2 workflows with new provider before committing fully.

```bash
# Test /start-task with Claude
cat .converted-workflows/claude/start-task.md | \
  curl https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    ...
```

### Tip 4: Document Your Choice

Add a note to `README.md` explaining which provider you're using and why.

```markdown
## AI Provider

**Selected: Claude (Anthropic)**

**Reason:** We need structured planning for complex features  
**Context Limit:** 200K tokens per request  
**Budget:** $20/month estimated  
**Setup:** Environment variable `ANTHROPIC_API_KEY`
```

### Tip 5: Monitor Costs

Set up billing alerts if using paid API providers.

```bash
# For Claude (Anthropic)
# Set budget alerts: https://console.anthropic.com/account/billing

# For Gemini
# Set budget alerts: https://cloud.google.com/billing
```

---

## 🚀 Next Steps

1. **Choose a provider** based on your needs (see comparison table above)
2. **Run converter:** `python3 scripts/ai-provider-converter.py --to <provider>`
3. **Read adapter guide:** CLAUDE_ADAPTER.md / GEMINI_ADAPTER.md / COPILOT_ADAPTER.md
4. **Set up authentication** for your chosen provider
5. **Test a workflow** with real project context
6. **Train your team** on the new provider's best practices
7. **Integrate with CI/CD** (optional, for automation)

---

## ❓ FAQ

**Q: Can I use multiple providers?**  
A: Yes! Use Claude for planning, Copilot for coding, Gemini for batch jobs. See "Advanced: Multi-Provider Strategy" below.

**Q: Do I need to rewrite my workflows?**  
A: No! Converter handles most adaptations. You might tweak for specific provider constraints.

**Q: Will Gemini work forever for free?**  
A: Google offers free tier (60 req/min). Paid tier is very cheap (~$0.075 per 1M tokens).

**Q: How do I switch back to Antigravity?**  
A: Your original workflows are unchanged in./workflows/. Just keep using them.

**Q: Can I contribute improvements to the converter?**  
A: Yes! The converter is in `scripts/ai-provider-converter.py`. PRs welcome!

---

## 🆘 Getting Help

1. **For converter issues:** Check troubleshooting section above
2. **For provider-specific questions:** Read the adapter guides
3. **For API setup:** See provider's official docs
4. **For bug reports:** File an issue with:
   - Provider you're using
   - Command you ran
   - Error message
   - Workflow file affected

---

## Advanced: Multi-Provider Strategy

### Recommended Setup for Teams

```
┌─────────────────────────────────────────────────────┐
│         Phase 1: Planning & Design                  │
│     Tool: Claude (structured thinking)              │
│   Input: /start-task workflow + requirements        │
│  Output: Architecture blueprint, test plan          │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│     Phase 2: Implementation & Code Gen              │
│   Tool: GitHub Copilot (IDE-based suggestions)      │
│   Input: Architecture from Phase 1                  │
│  Output: Implementation code, tests                 │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│      Phase 3: Review & Optimization                 │
│     Tool: Claude or Gemini (code review)            │
│   Input: Implemented code from Phase 2              │
│  Output: Review feedback, refactoring suggestions   │
└────────────────────┬────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────┐
│     Phase 4: Batch Testing / Documentation          │
│      Tool: Gemini (high throughput)                 │
│   Input: Tests + implementation from Phase 2-3      │
│  Output: Test results, documentation                │
└─────────────────────────────────────────────────────┘
```

**Implementation:**

```bash
# Day 1: Use Claude for planning
export ANTHROPIC_API_KEY="..."
cat .converted-workflows/claude/start-task.md | claude-api

# Day 2-3: Use Copilot for coding
# (Open files in VS Code, Copilot Chat triggers automatically)

# Day 4: Use Claude for code review
cat src/features/infinite_scroll/*.dart | claude-api

# Day 5: Use Gemini for batch testing
gemini < workflows/write-test.md > test-results.md
```

This gives you the **best of all worlds** while managing costs!

---

**Ready to start?** Run:

```bash
python3 scripts/ai-provider-converter.py --list-providers
```

Pick a provider and begin! 🚀
