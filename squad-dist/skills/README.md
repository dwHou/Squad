# Squad Skills Arsenal
**Version:** 1.0.0

## Overview

Skills are specialized capabilities that extend Squad agents beyond their core tools. The Squad framework integrates 16+ professional skills from Anthropic's official skills arsenal, enabling agents to handle complex tasks like document processing, frontend design, testing, and more.

---

## What are Skills?

**Skills vs. Tools:**
- **Tools** (Read, Write, Edit, Bash, Grep, Glob) - Core capabilities available to all agents
- **Skills** - Specialized modules for domain-specific tasks

**Skills vs. Agents:**
- **Agents** (Researcher, Engineer, Tester) - Complete workflow handlers with personality and context
- **Skills** - Focused utilities that agents can invoke when needed

**Think of skills as:**
- Expert consultants that agents can call upon
- Specialized libraries with battle-tested patterns
- Power-ups that extend agent capabilities

---

## Skill Categories

### 1. Frontend Design & UI
**Purpose:** Create exceptional web interfaces with distinctive aesthetics

| Skill | Description | Usefulness | Agents |
|-------|-------------|------------|--------|
| `frontend-design` | Production-grade interfaces with bold design | ⭐⭐⭐⭐⭐ (9/10) | Engineer:frontend, Engineer:fullstack |
| `web-artifacts-builder` | Complete web apps and prototypes | ⭐⭐⭐⭐ (8/10) | Engineer:frontend, Engineer:fullstack |
| `theme-factory` | Design systems with cohesive themes | ⭐⭐⭐⭐ (8/10) | Engineer:frontend, Engineer:fullstack |
| `algorithmic-art` | Generative art and visualizations | ⭐⭐⭐ (6/10) | Engineer:frontend |
| `canvas-design` | Canvas-based visual design | ⭐⭐⭐ (7/10) | Engineer:frontend |
| `brand-guidelines` | Brand identity documentation | ⭐⭐⭐ (7/10) | Engineer:frontend, Researcher:documentation |
| `slack-gif-creator` | Animated GIFs for messaging | ⭐⭐ (5/10) | Engineer:frontend |

### 2. Document Processing
**Purpose:** Read, write, and manipulate various document formats

| Skill | Description | Usefulness | Agents |
|-------|-------------|------------|--------|
| `doc-coauthoring` | Structured documentation workflow | ⭐⭐⭐⭐⭐ (9/10) | Researcher:documentation, Engineer:fullstack |
| `pdf` | PDF generation and manipulation | ⭐⭐⭐⭐⭐ (9/10) | Researcher:documentation, Engineer:fullstack |
| `docx` | Microsoft Word documents | ⭐⭐⭐⭐ (8/10) | Researcher:documentation, Engineer:fullstack |
| `xlsx` | Excel spreadsheets | ⭐⭐⭐⭐ (8/10) | Researcher:codebase, Engineer:backend |
| `pptx` | PowerPoint presentations | ⭐⭐⭐ (7/10) | Researcher:documentation, Engineer:fullstack |

### 3. Development & Tooling
**Purpose:** Build tools and extend Squad capabilities

| Skill | Description | Usefulness | Agents |
|-------|-------------|------------|--------|
| `mcp-builder` | Create MCP servers for API integration | ⭐⭐⭐⭐ (8/10) | Engineer:backend, Engineer:fullstack |
| `skill-creator` | Create new Squad skills | ⭐⭐⭐ (7/10) | Engineer:fullstack, Researcher:codebase |

### 4. Testing
**Purpose:** Automated testing and verification

| Skill | Description | Usefulness | Agents |
|-------|-------------|------------|--------|
| `webapp-testing` | Playwright-based web app testing | ⭐⭐⭐⭐⭐ (9/10) | Tester:e2e, Tester:integration, Engineer:fullstack |

### 5. Communications
**Purpose:** Draft communications and documentation

| Skill | Description | Usefulness | Agents |
|-------|-------------|------------|--------|
| `internal-comms` | Team announcements and status updates | ⭐⭐⭐ (7/10) | Researcher:documentation, Engineer:fullstack |

### 6. Translation (Special)
**Purpose:** Language translation and localization

| Skill | Description | Usefulness | Agents |
|-------|-------------|------------|--------|
| `translate` | Intelligent code and document translation | ⭐⭐⭐⭐⭐ (10/10) | All agents |

---

## How Agents Invoke Skills

### Method 1: Task Tool (Programmatic)
Agents use the `Task` tool to invoke skills programmatically:

```python
# Basic skill invocation
Task(skill="frontend-design", args="create cyberpunk-themed dashboard")

# With specific parameters
Task(skill="pdf", args="generate report with charts and tables")

# Multi-step workflow
Task(skill="doc-coauthoring", args="guide user through API documentation")
```

### Method 2: Natural Language (User-Facing)
When suggesting skills to users:

```
User: "I need to test my web application"
Agent: "I can use the webapp-testing skill with Playwright to:
        1. Navigate to your application
        2. Verify functionality
        3. Capture screenshots
        Shall I proceed?"
```

---

## Skill Discovery

### Automatic Discovery
Squad automatically suggests skills based on:
1. **Task keywords** - Matched against skill triggers in `skills.yaml`
2. **Agent context** - Each agent knows which skills are relevant to their domain
3. **Confidence threshold** - Only suggests skills with >0.8 confidence match

### Manual Discovery
Users can explicitly request skills:
```bash
/squad @engineer:frontend use frontend-design to create landing page
```

### Skill Registry
All skills are registered in `skills/skills.yaml` with metadata:
- Name and description
- Category and tags
- Trigger keywords
- Associated agents
- Usefulness rating
- Read-only and destructive hints

---

## Skill Usage by Agent

### Researcher Agent
**Primary skills:**
- `doc-coauthoring` - Writing technical documentation
- `translate` - Translating foreign language papers/docs
- `internal-comms` - Drafting team communications
- `brand-guidelines` - Documenting design systems

**Document reading:**
- `pdf`, `docx`, `pptx`, `xlsx` - Automatically available through Read tool

**Example:**
```python
# When user asks: "I need to write a technical spec"
Task(skill="doc-coauthoring", args="guide user through technical spec creation")
```

### Engineer Agent
**Frontend-specific:**
- `frontend-design` - Exceptional UI design
- `web-artifacts-builder` - Complete web apps
- `theme-factory` - Design systems
- `algorithmic-art` - Data visualizations

**Backend-specific:**
- `mcp-builder` - API integrations
- `xlsx` - Data export
- `pdf` - Report generation

**Fullstack:**
- All frontend and backend skills
- `doc-coauthoring` - Technical documentation
- `translate` - Bilingual documentation

**Example:**
```python
# When user asks: "Create a beautiful landing page"
Task(skill="frontend-design", args="create landing page with bold aesthetic direction")

# When user asks: "Export data to Excel"
Task(skill="xlsx", args="export user analytics to spreadsheet with charts")
```

### Tester Agent
**Primary skills:**
- `webapp-testing` - E2E and integration testing (HIGHLY RECOMMENDED for e2e tag)
- `translate` - Test report translation

**Example:**
```python
# When user asks: "Test the login flow"
Task(skill="webapp-testing", args="test login flow with Playwright on localhost:3000")
```

---

## Skill Best Practices

### When to Use Skills

**✅ DO use skills when:**
- Task matches skill's specialized domain
- Skill provides battle-tested patterns
- User explicitly requests specialized capability
- Skill would significantly improve output quality

**❌ DON'T use skills when:**
- Core tools (Read, Write, Edit) can handle it
- Task is simpler than skill's complexity
- Skill is overkill for the requirement

### Proactive Skill Suggestions

**Good approach:**
```
User: "Create a landing page"
Agent: "I can use the frontend-design skill to create a distinctive,
        production-grade landing page with bold aesthetics.
        This will go beyond basic HTML/CSS. Shall I proceed?"
```

**Bad approach:**
```
User: "Create a landing page"
Agent: *silently uses frontend-design without mentioning it*
```

### Skill Chaining

Some tasks benefit from multiple skills:

```python
# 1. Design the interface
Task(skill="frontend-design", args="create dashboard with data visualizations")

# 2. Test the result
Task(skill="webapp-testing", args="verify dashboard renders correctly and interactions work")

# 3. Document the work
Task(skill="doc-coauthoring", args="create component documentation")
```

---

## Skill Development

### Adding New Skills

To add new skills to Squad:

1. **Create skill directory:**
   ```bash
   mkdir squad-dist/skills/my-new-skill
   ```

2. **Create SKILL.md:**
   ```markdown
   ---
   name: my-new-skill
   description: Brief description
   license: Complete terms in LICENSE.txt
   ---

   # Skill content here
   ```

3. **Register in skills.yaml:**
   ```yaml
   my-new-skill:
     name: my-new-skill
     category: development-tools
     description: Detailed description
     usefulness: 8
     agents:
       - engineer:fullstack
     triggers:
       - "keyword1"
       - "keyword2"
   ```

4. **Update agent definitions** to reference the new skill

5. **Test and commit**

For detailed guidance, use the `skill-creator` skill:
```python
Task(skill="skill-creator", args="create skill for automated code review")
```

---

## Skill Registry Location

**Skills are installed to:**
- `~/.claude/skills/` - For Claude Code
- `~/.cursor/skills/` - For Cursor IDE
- Squad automatically detects which IDE is active

**Skill registry:**
- `squad-dist/skills/skills.yaml` - Source of truth (edit here)
- Copied during installation via `install.sh`

---

## Extensibility

Skills are designed to be:
1. **Modular** - Each skill is self-contained
2. **Discoverable** - Registered in central skills.yaml
3. **Composable** - Can be chained together
4. **Extensible** - Easy to add new skills
5. **IDE-agnostic** - Work in both Claude Code and Cursor

---

## Skill Lifecycle

### Installation
```bash
./install.sh
# Copies all skills to ~/.claude/skills/ and ~/.cursor/skills/
```

### Update
```bash
# Edit skills in squad-dist/skills/
# Then reinstall
./install.sh --clean
```

### Removal
```bash
./install.sh --uninstall
# Removes all installed skills
```

---

## Version History

- **v1.0.0** - Initial skills integration with 16+ skills from Anthropic arsenal
  - Frontend design skills: 7 skills
  - Document processing: 5 skills
  - Development tools: 2 skills
  - Testing: 1 skill
  - Communications: 1 skill
  - Translation: 1 core skill

---

## Further Reading

- **Skills Registry:** `skills/skills.yaml` - Full skill metadata
- **Agent Definitions:** `agents/*.md` - How agents use skills
- **Core Rules:** `rules/00-squad-core.md` - Skills system integration
- **Individual Skills:** `skills/*/SKILL.md` - Detailed skill documentation

---

<p align="center">
  <b>Squad Skills Arsenal</b><br>
  Extending Squad agents with specialized capabilities
</p>
