# Squad Roadmap

This document outlines the development plan for Squad, from MVP to advanced features.

---

## v0.1.0 - MVP (Current) ✅

**Goal:** Minimal viable product with core functionality

### Features
- ✅ 3 core agents (Researcher, Engineer, Tester)
- ✅ Tag system for specialization
- ✅ Simple keyword-based routing
- ✅ Serial execution model
- ✅ Bilingual support (English/Chinese)
- ✅ Basic configuration system
- ✅ Installation script

### Architecture
- Rules-based routing (no external dependencies)
- YAML configuration
- Markdown-based agent definitions
- Direct Claude Code integration

---

## v0.2.0 - Enhanced Routing

**Goal:** Smarter, more accurate task routing

### Features
- [ ] **Pattern matching** - Regex-based route patterns
- [ ] **Confidence scoring** - Weight-based confidence calculation
- [ ] **Low-confidence handling** - Ask user when uncertain
- [ ] **Routing analytics** - Track routing accuracy
- [ ] **User corrections** - Learn from manual overrides

### Example
```bash
/squad implement login feature

→ Task analysis:
  - Pattern match: "implement .* feature" → fullstack
  - Keywords: [implement, login, feature]
  - Confidence: 0.85 (high)
→ Routing: Engineer:fullstack
```

### Technical Changes
- Add `patterns` section to router.yaml
- Implement confidence scoring algorithm
- Add routing history log
- Optional interactive mode for low confidence

---

## v0.3.0 - Agent Expansion

**Goal:** Add specialized agents for specific domains

### New Agents

#### Architect / 架构师
**Purpose:** System design and technical decisions

**Tags:**
- `system` - High-level architecture
- `database` - Database schema design
- `api` - API design

**Model:** Opus (requires deep thinking)

#### Reviewer / 审查员
**Purpose:** Code review and quality checks

**Tags:**
- `security` - Security audit
- `performance` - Performance analysis
- `style` - Code style review

**Model:** Sonnet

#### Translator / 翻译员
**Purpose:** Code documentation and translation

**Tags:**
- `docs` - Documentation generation
- `comments` - Code comment translation
- `i18n` - Internationalization support

**Model:** Haiku

### Backward Compatibility
- All v0.1.0 agents remain unchanged
- Existing routes still work
- New agents are opt-in

---

## v0.4.0 - Multi-Agent Workflows

**Goal:** Enable complex multi-step workflows

### Features
- [ ] **Workflow templates** - Pre-defined agent sequences
- [ ] **Conditional routing** - Route based on previous results
- [ ] **Agent handoff** - Pass context between agents
- [ ] **Workflow visualization** - Show planned execution path

### Example Workflows

#### Feature Implementation
```yaml
workflow: feature
steps:
  - researcher:codebase     # Understand existing code
  - architect:system        # Design approach
  - engineer:fullstack      # Implement
  - tester:unit            # Test
  - reviewer:security      # Security check
```

#### Bug Fix
```yaml
workflow: bugfix
steps:
  - researcher:codebase     # Find bug location
  - engineer:fullstack      # Fix bug
  - tester:unit            # Verify fix
```

### Technical Changes
- Add workflow definitions in `~/.squad/workflows/`
- Implement workflow execution engine
- Add context passing between agents
- Workflow state management

---

## v0.5.0 - Context & Memory

**Goal:** Persistent context and learning

### Features
- [ ] **Session memory** - Remember context within session
- [ ] **Project memory** - Persist project-specific knowledge
- [ ] **Routing history** - Learn from past routing decisions
- [ ] **User preferences** - Remember user's preferred routes

### Example
```bash
# First time
/squad fix button issue
→ Engineer:fullstack (default)

# After learning (user corrects to frontend)
/squad fix button issue
→ Engineer:frontend (learned from correction)
```

### Storage
```
~/.squad/memory/
├── sessions/
│   └── 2024-01-15.json
├── projects/
│   └── my-project/
│       ├── routing_history.json
│       └── preferences.json
└── global_preferences.json
```

---

## v0.6.0 - Advanced Routing

**Goal:** ML-based intelligent routing

### Features
- [ ] **Embedding-based classification** - Use embeddings for task similarity
- [ ] **Context-aware routing** - Consider project type, file structure
- [ ] **Multi-language NLP** - Better Chinese/English support
- [ ] **Domain-specific models** - Custom routing for specific project types

### Technical Stack
- Lightweight ML model (ONNX runtime)
- Local inference (no API calls)
- Optional feature (fallback to keyword matching)

---

## v0.7.0 - Collaboration Features

**Goal:** Team-wide Squad usage

### Features
- [ ] **Shared routing rules** - Team-wide router.yaml
- [ ] **Agent templates** - Reusable agent definitions
- [ ] **Routing statistics** - Team routing analytics
- [ ] **Best practices** - Suggested routes based on team patterns

### File Sharing
```
project/.squad/
├── team_router.yaml         # Team routing rules
├── team_agents/             # Custom team agents
└── analytics/               # Usage statistics
```

---

## v0.8.0 - Performance Optimization

**Goal:** Faster, more efficient execution

### Features
- [ ] **Parallel execution (opt-in)** - Run cheap agents in parallel
- [ ] **Caching** - Cache agent responses for identical tasks
- [ ] **Incremental execution** - Resume from failed steps
- [ ] **Resource limits** - Token budgets, time limits

### Smart Parallelization
```yaml
# Expensive agents: serial (one at a time)
engineer:fullstack:
  parallel: false

# Cheap agents: parallel (multiple at once)
researcher:codebase:
  parallel: true
  max_concurrent: 3
```

---

## v0.9.0 - Integration & Ecosystem

**Goal:** Work seamlessly with other tools

### Integrations
- [ ] **Git integration** - Auto-commit after changes
- [ ] **CI/CD hooks** - Trigger on PR, push
- [ ] **IDE extensions** - VSCode, JetBrains integration
- [ ] **Slack/Discord** - Notifications and summaries

### Ecosystem
- [ ] **Agent marketplace** - Share custom agents
- [ ] **Workflow library** - Community workflows
- [ ] **Plugin system** - Extend Squad functionality

---

## v1.0.0 - Production Ready

**Goal:** Stable, well-documented, production-grade

### Requirements
- ✅ All core features stable
- ✅ Comprehensive documentation
- ✅ Test coverage > 80%
- ✅ Performance benchmarks
- ✅ Security audit
- ✅ Migration guides

### Guarantees
- **Backward compatibility** - v0.x configs still work
- **Stability** - No breaking changes in v1.x
- **Support** - Issue response within 48h
- **Updates** - Security patches, bug fixes

---

## Beyond v1.0

### Potential Features
- **Visual workflow builder** - Drag-and-drop agent orchestration
- **Agent marketplace** - Buy/sell custom agents
- **Cloud sync** - Sync config across devices
- **Squad-as-a-service** - Hosted Squad for teams
- **Multi-repo support** - Coordinate across projects
- **Real-time collaboration** - Multiple users, one Squad

---

## Release Schedule

**Current Phase:** MVP (v0.1.0)

**Target Timeline:**
- v0.2.0 - Q1 2024 (2 months)
- v0.3.0 - Q2 2024 (3 months)
- v0.4.0 - Q3 2024 (3 months)
- v0.5.0 - Q4 2024 (3 months)
- v1.0.0 - Q1 2025 (6 months)

**Note:** Timeline is flexible and depends on:
- Community feedback
- Feature adoption
- Technical challenges
- Contributor availability

---

## How to Contribute

Want to help build Squad? Here's how:

### For v0.2.0 (Enhanced Routing)
- Implement pattern matching
- Add confidence scoring
- Build routing analytics
- Write tests

### For v0.3.0 (Agent Expansion)
- Design new agents (Architect, Reviewer, etc.)
- Write agent documentation
- Test agent behavior
- Create usage examples

### For v0.4.0+ (Advanced Features)
- Design workflow syntax
- Implement workflow engine
- Build ML routing models
- Create integrations

---

## Feedback Welcome

This roadmap is **not set in stone**. We want to hear from you:

- Which features matter most?
- What's missing?
- What should we prioritize?
- What should we cut?

**Discuss:** [GitHub Discussions](https://github.com/yourusername/squad/discussions)

---

## Principles Guiding Development

### 1. Start Simple
Don't build features before they're needed.

### 2. Token Efficiency
Always prioritize cost over speed.

### 3. Backward Compatibility
v0.1.0 configs should work in v1.0.0.

### 4. User Choice
Advanced features should be opt-in, not forced.

### 5. Clear Over Clever
Readable code and docs over clever implementations.

---

<p align="center">
  <b>Squad Roadmap</b><br>
  From MVP to production-grade multi-agent orchestration
</p>
