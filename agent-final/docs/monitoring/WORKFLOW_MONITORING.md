# Workflow Monitoring & Observability (PHASE 7)

**Version:** 1.0.0  
**Status:** Real-time Monitoring System  
**Purpose:** Provide complete visibility into active workflows with debugging & troubleshooting

---

## 1. Monitoring Architecture

### 1.1 Observability Stack

```
Instrumentation Layer:
├─ Workflow events (Start, Step Progress, Complete, Error)
├─ Skill invocations (Duration, Tokens Used, Quality)
├─ Cache operations (Load, Save, Hit/Miss, Latency)
├─ Approval gates (Automatic/Manual, Decision, Duration)
└─ System events (Memory, CPU, Disk, Network)
    ↓
Collection Layer:
├─ Local event buffer (in-memory + disk)
├─ Stream processor (real-time aggregation)
└─ Time-series database (InfluxDB or similar)
    ↓
Query Layer:
├─ Real-time queries (< 1 second latency)
├─ Historical queries (with aggregations)
└─ Full-text search (logs, traces)
    ↓
Visualization Layer:
├─ Web dashboard (real-time updates)
├─ CLI commands (orchctl)
└─ Alerts & notifications
```

### 1.2 Data Model

```dart
/// Workflow event that gets recorded
class WorkflowEvent {
  final String trace_id;
  final String workflow_id;
  final EventType event_type;  // start, step_begin, step_end, complete, error
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final Duration duration;

  // Example:
  // trace_id: "ctx_feature_dark_001"
  // workflow_id: "implement-feature"
  // event_type: "step_begin"
  // timestamp: 2026-03-10T10:05:00Z
  // data: { step: 3, step_name: "Domain Implementation" }
  // duration: null (until step_end)
}

/// Aggregated workflow state
class WorkflowState {
  final String trace_id;
  final String workflow_id;
  final WorkflowStatus status;  // pending, in_progress, awaiting_input, completed, failed
  final int current_step;
  final int total_steps;
  final DateTime started_at;
  final DateTime estimated_completion;
  final Duration elapsed;
  final Duration estimated_remaining;

  final Map<int, StepStatus> step_statuses;
  final Map<String, dynamic> context;
  final List<String> errors;
}
```

---

## 2. Real-time Monitoring CLI

### 2.1 CLI Commands

```bash
# Watch active workflows in real-time (updates every second)
$ orchctl watch workflows

  TRACE_ID                        WORKFLOW              STATUS            PROGRESS
  ──────────────────────────────────────────────────────────────────────────────
  ctx_feature_dark_001            implement-feature     IN_PROGRESS       45% ████░░░░░
  ctx_task_new_gallery_002        start-task            IN_PROGRESS       50% █████░░░░
  ctx_fix_crash_stream_003        fix                   AWAITING_INPUT    ⏸  (manual approval needed)

  Updated: 2026-03-10 10:15:32 UTC | Press 'q' to exit | Press 'h' for help

# Watch specific workflow
$ orchctl watch workflow ctx_feature_dark_001

  ┌─ WORKFLOW: implement-feature ─────────────────────────────────────┐
  │ TRACE_ID:         ctx_feature_dark_001                           │
  │ Status:           IN_PROGRESS                                    │
  │ Progress:         45% ████████░░░░░░ (4.5/10 min)               │
  │ Started:          2026-03-10 10:05:00 UTC (7 min ago)           │
  │ Estimated End:    2026-03-10 10:50:00 UTC (35 min from now)     │
  │                                                                  │
  │ Current Step:     5/8                                            │
  │ Step Name:        Presentation Layer Implementation             │
  │ Step Progress:    30% ███░░░░░░░                                 │
  │ Parallelization:  ENABLED (STEP 4 running concurrently)         │
  │                                                                  │
  │ Tokens Used:      18,500 / 29,000 (64%)                         │
  │ Cache Hits:       3/3 (100%)                                    │
  │ Skill Invoked:    vibecoder                                      │
  │ Skill Duration:   15m so far                                    │
  │                                                                  │
  └──────────────────────────────────────────────────────────────────┘

  Recent Events:
  ├─ 2026-03-10 10:15:00  [STEP 5] Presentation Layer Implementation started
  ├─ 2026-03-10 10:10:00  [STEP 4] Data Layer Implementation completed (33m)
  ├─ 2026-03-10 10:09:00  [CACHE]  Context loaded from cache (0 tokens)
  └─ 2026-03-10 10:05:00  [START]  Workflow started (parallel mode)

  Logs: `/Users/tuanvm/.agents/logs/ctx_feature_dark_001.log` (tail -f to follow)

# View workflow history
$ orchctl history workflows implement-feature --days 7

  Date                Success  Total  Avg Time  Quality  Parallelized
  ─────────────────────────────────────────────────────────────────────
  2026-03-10 (today)  11/12    12     105m     8.6     100%
  2026-03-09          10/10    10     106m     8.5     100%
  2026-03-08          9/10     10     108m     8.4     90%
  2026-03-07          8/9      9      110m     8.3     78%
  2026-03-06          7/8      8      112m     8.2     50%
  ─────────────────────────────────────────────────────────────────────
  Average             45/49    49     108m     8.4     84%

# Tail logs for specific workflow
$ orchctl logs ctx_feature_dark_001 -f

  [10:15:32] [STEP 5] [vibecoder] Started Presentation Layer Implementation
  [10:15:31] [CACHE] Cache lookup: hit (173 KB, load time: 12ms)
  [10:15:30] [SKILL] Invoking vibecoder with context (29K tokens)
  [10:15:28] [ORCHESTRATOR] Parallelization: STEP 4 + STEP 5 concurrent
  [10:15:25] [STEP 4] [vibecoder] Completed Data Layer Implementation (30m)
  [10:15:20] [CONTEXT] Saving step delta to cache
  [10:10:00] [STEP 3] [vibecoder] Completed Domain Implementation (20m)
  ...

# Get detailed workflow state
$ orchctl status ctx_feature_dark_001 --json

  {
    "trace_id": "ctx_feature_dark_001",
    "workflow_id": "implement-feature",
    "status": "in_progress",
    "current_step": 5,
    "total_steps": 8,
    "started_at": "2026-03-10T10:05:00Z",
    "elapsed_minutes": 7,
    "estimated_remaining_minutes": 35,

    "step_statuses": {
      "1": {"name": "DoR Verification", "status": "completed", "duration": 5},
      "2": {"name": "Domain Design", "status": "completed", "duration": 15},
      "3": {"name": "Domain Impl", "status": "completed", "duration": 20},
      "4": {"name": "Data Layer", "status": "completed", "duration": 30},
      "5": {"name": "Presentation", "status": "in_progress", "duration": 7},
      "6": {"name": "Code Generation", "status": "pending", "duration": null},
      "7": {"name": "Tests", "status": "pending", "duration": null},
      "8": {"name": "Quality Audit", "status": "pending", "duration": null}
    },

    "parallelization": {
      "enabled": true,
      "parallel_group": "layer_impl",
      "parallel_steps": [4, 5],
      "step_4_status": "completed",
      "step_5_status": "in_progress"
    },

    "caching": {
      "enabled": true,
      "cache_hits": 3,
      "cache_misses": 0,
      "tokens_saved": 87000
    },

    "errors": []
  }

# Compare workflow performance
$ orchctl compare workflows implement-feature \
  --baseline 2_weeks_ago \
  --current now

  Metric                     2 Weeks Ago   Current    Change
  ──────────────────────────────────────────────────────────────
  Avg Execution Time         125 min       105 min    -20 min (-16%)
  Success Rate               88%           92%        +4%
  Parallelization Enabled    30%           100%       +70%
  Cache Hit Rate             75%           88%        +13%
  Avg Quality Score          8.1           8.6        +0.5
  Avg Tokens per Run         120k          29k        -91k (-76%)
  Avg Cost per Run           $1.80         $0.44      -$1.36 (-76%)
```

### 2.2 Log Levels

```
DEBUG:    Detailed execution trace (skill invocation details, token usage)
INFO:     Key events (step started, cache hit, approval decision)
WARN:     Non-critical issues (performance degradation, deprecated features)
ERROR:    Recoverable errors (transient network issue, retry attempt)
FATAL:    Unrecoverable errors (workflow stops)
```

### 2.3 Example Log File

```
# File: ~/.agents/logs/ctx_feature_dark_001.log

[2026-03-10T10:05:00.123Z] [INFO]  [ORCHESTRATOR] Workflow started
  trace_id=ctx_feature_dark_001
  workflow_id=implement-feature
  execution_mode=parallel
  caching_enabled=true

[2026-03-10T10:05:05.456Z] [INFO]  [STEP 1] DoR Verification started
  skill_name=tech-lead

[2026-03-10T10:05:10.789Z] [DEBUG] [SKILL: tech-lead] Invoked
  input_tokens=15000
  output_tokens=3200

[2026-03-10T10:05:12.012Z] [INFO]  [STEP 1] DoR Verification completed
  duration_minutes=5
  status=completed
  dor_completeness=100

[2026-03-10T10:05:13.345Z] [INFO]  [CACHE] Saving full context
  trace_id=ctx_feature_dark_001
  context_size_kb=250
  compression=gzip

[2026-03-10T10:05:15.678Z] [INFO]  [STEP 2] Domain Design started
  skill_name=tech-lead

[2026-03-10T10:05:30.901Z] [DEBUG] [SKILL: tech-lead] Invoked
  input_tokens=2000
  output_tokens=4100
  cache_loaded=yes

[2026-03-10T10:05:35.234Z] [INFO]  [STEP 2] Domain Design completed
  duration_minutes=15
  status=completed

[2026-03-10T10:05:36.567Z] [INFO]  [CACHE] Step delta saved
  step=2
  delta_tokens=1500
  cache_updated=yes

[2026-03-10T10:05:40.890Z] [INFO]  [STEP 3] Domain Impl started
  skill_name=vibecoder

[2026-03-10T10:06:00.123Z] [DEBUG] [SKILL: vibecoder] Invoked
  input_tokens=2500
  output_tokens=12000
  cache_loaded=yes

[2026-03-10T10:06:00.234Z] [INFO]  [ORCHESTRATOR] Parallel group "layer_impl" starting
  parallel_steps=[4, 5]
  barrier_after=true

[2026-03-10T10:06:00.456Z] [INFO]  [STEP 4] Data Layer Impl started (ASYNC)
  skill_name=vibecoder

[2026-03-10T10:06:00.678Z] [INFO]  [STEP 5] Presentation Layer started (ASYNC)
  skill_name=vibecoder

[2026-03-10T10:15:32.901Z] [INFO]  [ORCHESTRATOR] Parallel group "layer_impl" completed
  step_4_duration_minutes=30
  step_5_duration_minutes=15
  time_saved_minutes=15
```

---

## 3. Profiling & Performance Analysis

### 3.1 Execution Timeline Visualization

```
$ orchctl profile ctx_feature_dark_001

Timeline: Execution Profile (105 minutes total)

┌─────────────────────────────────────────────────────────────────┐
│ STEP 1: DoR Verification (tech-lead)        5 min              │
│ ████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Time: 0-5m                                                      │
│ Skill: tech-lead (4.2 min) + overhead (0.8 min)               │
│ Cache: N/A (first step)                                        │
│ Tokens: 18,200 / 29,000                                        │
│ Quality: N/A                                                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ STEP 2: Domain Design (tech-lead)          15 min              │
│ ████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Time: 5-20m                                                     │
│ Skill: tech-lead (5.2 min) + cache load (0.1 min)             │
│ Cache: Hit (174 KB), saved 15,000 tokens                       │
│ Tokens: 2,000 / 29,000 (cache saved: 15,000)                   │
│ Quality: N/A                                                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ STEP 3: Domain Implementation (vibecoder)  20 min              │
│ ████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Time: 20-40m                                                    │
│ Skill: vibecoder (19.1 min) + cache (0.2 min)                  │
│ Cache: Hit (174 KB), saved 15,000 tokens                       │
│ Tokens: 4,000 / 29,000                                         │
│ Quality: N/A                                                    │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ ║ PARALLEL GROUP: layer_impl ║                                  │
│ ║                                                                │
│ │ STEP 4: Data Layer (vibecoder)             30 min             │
│ │ ████████████████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ │ Time: 40-70m                                                  │
│ │ Cache: Hit (174 KB), saved 15,000 tokens                     │
│ │ Tokens: 3,500 / 29,000                                       │
│ │                            ┌────────────────────────────────┐
│ │                            │ STEP 5: Presentation          │
│ │                            │ (vibecoder) - CONCURRENT      │
│ │                            │ ████████████████░░░░░░░░░░░░ │
│ │                            │ Time: 40-55m (only 15m!)      │
│ │                            │ Cache: Hit                     │
│ │                            │ Tokens: 3,200 / 29,000        │
│ │                            └────────────────────────────────┘
│ │ Parallelization Impact: Saved 15 minutes! ⚡                │
│ ║                                                                │
│ └─────────────────────────────────────────────────────────────────┘
│
│
│ STEP 6: Code Generation (build_runner)       5 min             │
│ █████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Time: 70-75m (barrier waits for STEP 5 to complete)           │
│ Cache: N/A (system step)                                       │
│────────────────────────────────────────────────────────────────  │

│ STEP 7: Write Tests (test-engineer)         10 min             │
│ ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Time: 75-85m                                                    │
│ Cache: Hit, saved 6,000 tokens                                 │
│ Tokens: 2,000 / 29,000                                         │
│ Quality: Coverage 85%                                           │
│────────────────────────────────────────────────────────────────  │

│ STEP 8: Quality Audit (code-quality-auditor) 10 min            │
│ ██████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│ Time: 85-95m                                                    │
│ Cache: Hit, saved 6,000 tokens                                 │
│ Tokens: 2,000 / 29,000                                         │
│ Quality: Score 8.6/10 ✅                                       │
└─────────────────────────────────────────────────────────────────┘

Summary:
├─ Total Time: 105 minutes (vs 125 min baseline = 16% faster)
├─ Parallel Group Saved: 15 minutes (STEP 4 & 5 concurrent)
├─ Total Tokens Used: 28,700 / 29,000 (99% of budget)
├─ Tokens Saved by Cache: 76,000 tokens (76% reduction)
└─ Quality Score: 8.6/10 ✅
```

### 3.2 Bottleneck Detection

```
$ orchctl analyze performance ctx_feature_dark_001

BOTTLENECK ANALYSIS
═════════════════════════════════════════════════════════════════

Time Distribution:
├─ Domain Impl (STEP 3): 20 min (19% of total) ← Longest sequential
├─ Data Layer (STEP 4): 30 min (parallelized)
├─ Presentation (STEP 5): 15 min (parallelized, saved 15m)
├─ Code Generation (STEP 6): 5 min (fast)
├─ Tests (STEP 7): 10 min (normal for coverage)
├─ Quality Audit (STEP 8): 10 min (comprehensive)
└─ Design Steps (1-2): 20 min (normal)

Opportunities:
1. STEP 3 Domain Impl (20 min)
   └─ Could be parallelized with design phase?
   └─ Current bottleneck: requires completed design output
   └─ Recommendation: Monitor in future, not a priority

2. STEP 7 Tests (10 min)
   └─ Could run concurrently with STEP 6 code gen?
   └─ Current dependency: requires generated code
   └─ Recommendation: Could save 5 min in future optimization

3. STEP 8 Quality Audit (10 min)
   └─ Could include async file scanning?
   └─ Recommendation: Low priority, already fast

Current Optimization Score: 8.5/10
✅ Parallelization working well
✅ Caching effective
⚠️ Minor optimization opportunities for PHASE 8+
```

---

## 4. Debugging & Troubleshooting

### 4.1 Debug Commands

```bash
# Get detailed debugging info for failed workflow
$ orchctl debug ctx_feature_auth_failed

  WORKFLOW DEBUG REPORT
  ═════════════════════════════════════════════════════════════

  Trace ID:       ctx_feature_auth_failed
  Status:         FAILED
  Failure Point:  STEP 8 (Quality Audit)
  Failed At:      2026-03-10 11:30:45 UTC
  Duration:       110 minutes

  FAILURE DETAILS
  ───────────────────────────────────────────────────────────
  Skill:          code-quality-auditor
  Error Type:     QualityAuditFailed
  Error Message:  "Architecture Score 6.2 < threshold 8.0"

  CONTEXT AT FAILURE
  ───────────────────────────────────────────────────────────
  Previous Step:  STEP 7 (Tests) - PASSED
  Test Coverage:  86% ✅
  Linter Warnings: 0 ✅

  AUDIT FINDINGS (Why it failed)
  ───────────────────────────────────────────────────────────
  Architecture Issues:
  ├─ ❌ Domain layer has circular dependency
  │   Location: lib/features/auth/domain/use_case.dart:42
  │   Issue: AuthRepository imported in domain entity
  │   Severity: HIGH - violates Clean Architecture
  │
  └─ ❌ Missing error handling
      Location: lib/features/auth/data/data_source.dart:28
      Issue: Network error not caught in try/catch
      Severity: MEDIUM - causes potential crash

  Code Quality Issues:
  ├─ Performance: 7/10 (acceptable)
  ├─ Security: 8/10 (acceptable)
  ├─ Test Coverage: 9/10 (excellent)
  └─ Maintainability: 6/10 (too low, needs refactor)

  RECOVERY STEPS
  ───────────────────────────────────────────────────────────
  1. Fix circular dependency in domain layer
     File: lib/features/auth/domain/use_case.dart:42
     Remove: import 'package:kansuke_photo/data/...

  2. Add error handling in data source
     File: lib/features/auth/data/data_source.dart:28
     Add: try/catch with specific exception handling

  3. Re-run quality audit
     $ orchctl workflow retry ctx_feature_auth_failed

  4. Estimated fix time: 15 minutes

  NEXT STEPS
  ───────────────────────────────────────────────────────────
  [ ] Review audit findings
  [ ] Make recommended code changes
  [ ] Re-run workflow
  [ ] Verify quality score >= 8.0

# View skill-level debugging
$ orchctl debug skill vibecoder --after 2026-03-10T10:00:00Z

  SKILL: vibecoder
  ════════════════════════════════════════════════════════════

  Recent Invocations (Last 1 hour):
  ├─ [1] ctx_feature_dark_001 - STEP 3 (Domain Impl)
  │   Status: ✅ Success (20 min)
  │   Quality: 9/10
  │   Tokens: 4,100
  │
  ├─ [2] ctx_feature_dark_001 - STEP 4 (Data Layer)
  │   Status: ✅ Success (30 min)
  │   Quality: 8/10
  │   Tokens: 3,500
  │
  ├─ [3] ctx_feature_dark_001 - STEP 5 (Presentation)
  │   Status: ✅ Success (15 min)
  │   Quality: 8/10
  │   Tokens: 3,200
  │
  └─ [4] ctx_feature_auth_failed - STEP 5 (Presentation)
      Status: ⚠️ Warning (18 min - slow!)
      Quality: 6/10 (below expected 8/10)
      Tokens: 3,800
      Issue: Code quality issues causing audit failure

  Average Performance:
  ├─ Success Rate: 100% (4/4)
  ├─ Avg Duration: 20.75 min (slightly slow)
  ├─ Avg Quality: 7.75/10 (below 8.0 target)
  └─ Recommendation: All metrics acceptable

# Get trace data
$ orchctl trace ctx_feature_dark_001 --format json | jq '.events | length'

  187 events recorded

$ orchctl trace ctx_feature_dark_001 --filter 'event_type == "cache"'

  Event 3:   Cache save (full context)  [10:05:13] 250 KB
  Event 7:   Cache load                  [10:05:15] 0 tokens saved
  Event 10:  Cache load                  [10:05:30] 15,000 tokens saved
  Event 18:  Cache update (step delta)   [10:06:00] 1,500 B written
```

### 4.2 Common Issues & Solutions

```yaml
issue_1:
  name: "Workflow running slow"
  symptoms:
    - Actual time > 20% above estimate
    - STEP X taking longer than baseline
  diagnosis:
    - Check: Is parallelization enabled?
    - Check: Is cache hit rate normal (> 80%)?
    - Check: Is skill output quality acceptable?
  solutions:
    - Reduce context size (fewer entities/use cases)
    - Check if input data is larger than expected
    - Verify skill quality is acceptable (may indicate rework needed)
  command: "orchctl analyze performance [trace_id]"

issue_2:
  name: "Quality audit failing"
  symptoms:
    - Workflow fails at STEP 8
    - Architecture score < 8.0
  diagnosis:
    - Review audit findings in detail
    - Identify specific violations (circular deps, missing error handling, etc.)
  solutions:
    - Fix architectural issues first
    - Add missing error handling
    - Consider if complexity > 7, feature-architect should have been invoked
  command: "orchctl debug [trace_id]"

issue_3:
  name: "Cache miss rate high"
  symptoms:
    - Cache hit rate < 80% (was 89% baseline)
  diagnosis:
    - New workflow patterns (different context structure)?
    - Cache corrupted/invalidated?
    - Disk space issue?
  solutions:
    - Check cache directory size (should be < 500 MB)
    - Run cache cleanup: "orchctl cache cleanup"
    - Monitor if new feature has unique context
  command: "orchctl cache stats"

issue_4:
  name: "Auto-approval not triggering"
  symptoms:
    - confidence_score > 0.85 but manual approval still required
  diagnosis:
    - Auto-approval gate not configured?
    - Orchestrator version mismatch?
  solutions:
    - Verify workflow YAML has auto_approval_gate
    - Check orchestrator is PHASE 6+ version
    - Review bug-investigator output field
  command: "orchctl workflow show [workflow_id]"
```

---

## 5. Success Criteria (PHASE 7)

✅ **Real-time Monitoring:**

- [x] `orchctl watch` commands working
- [x] Live status updates (< 1 second latency)
- [x] Event logging comprehensive
- [x] Log file analysis tools functional

✅ **Debugging & Troubleshooting:**

- [x] `orchctl debug` provides actionable insights
- [x] Performance profiling accurate
- [x] Bottleneck detection identifies optimization opportunities
- [x] Common issues documented with solutions

✅ **Integration:**

- [x] CLI commands comprehensive
- [x] JSON export for integrations
- [x] Log files searchable and analyzable
- [x] Alerts connected to monitoring

---

**Document Version:** 1.0.0  
**Status:** ✅ Real-time Monitoring System Ready  
**Last Updated:** 2026-03-10  
**Next:** Advanced /fix parallelization & ML confidence scoring
