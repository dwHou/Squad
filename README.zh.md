# Squad

> **面向 Claude Code 的高效多智能体编排框架**

[![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)](https://github.com/yourusername/squad/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**[中文](#)** | **[English](README.md)**

---

## 什么是 Squad？

**Squad** 是为 Claude Code 设计的轻量级多智能体框架。它不同于并行运行多个智能体（成本高昂！）的方式，Squad 使用**智能路由 (intelligent routing)** 和**串行执行 (serial execution)** 来高效协调专业化的智能体。

可以将其理解为**领导一个专注的工程团队**，每个成员都有特定的角色，任务会在合适的时间分配给合适的人。

```
用户请求
     ↓
  路由器  ────→  正确的智能体，正确的任务
     ↓
  执行   ────→  高效节省 Token，串行执行
     ↓
  结果   ────→  清晰、可执行
```

---

## ✨ 核心特性

### 🎯 路由可见性
**新功能！** 每个任务在执行前都会显示由哪个智能体处理：
```
🎯 @engineer:frontend
```
实时查看 Squad 的决策过程。

### 🔄 持久化模式
只需进入 Squad 模式一次，无需每次都输入 `/squad` 即可持续使用：
```bash
/squad                  # 进入持久化模式
fix login button        # 自动路由
add dark mode           # 自动路由
/exit                   # 完成后退出
```

### 🛡️ 权限级别
选择 Squad 智能体的自主程度：
- **保守模式 (Conservative)** - 每个操作前都询问（安全）
- **平衡模式 (Balanced)** - 自动允许常见操作，关键操作需确认（推荐）
- **自主模式 (Autonomous)** - 适用于 24 小时以上任务的完全自动化

### 🧠 自我进化
Squad 从你的反馈中学习并自我改进：
```bash
/squad reflect          # 分析对话，提出改进建议
/squad rollback <id>    # 需要时撤销变更
```

### 🏃 串行执行
智能体一次运行一个，在保持质量的同时最小化 Token 消耗。

### 🏷️ 标签系统
每个智能体支持专业化标签（例如 `engineer:frontend`、`engineer:backend`），无需智能体爆炸式增长。

### 🌐 双语支持
完整的中英文支持。一条命令即可切换语言。

### 📈 可扩展设计
从简单开始，根据需要增长。路由逻辑和智能体定义之间有清晰的分离。

---

## 快速开始

### 安装

```bash
# 克隆仓库 (repository)
git clone https://github.com/yourusername/squad.git
cd squad

# 安装
./install.sh

# 或清洁安装（首先移除旧版本）
./install.sh --clean
```

安装程序将：
1. 复制规则到 `~/.claude/rules/`
2. 复制智能体定义到 `~/.claude/agents/`
3. 复制命令到 `~/.claude/commands/`
4. 在 `~/.squad/` 中创建路由器配置
5. 可选地添加文件权限

### 首次设置

运行配置向导：

```bash
/squad config
```

选择：
1. **语言** - English 或 中文
2. **权限级别** - 保守模式、平衡模式或自主模式

### 使用模式

#### 🔄 持久化模式（推荐）

只需进入 Squad 模式一次，持续使用：

```bash
# 进入持久化模式
/squad

# 现在你的所有消息都会自动路由
fix login button                    → 🎯 @engineer:frontend
optimize database queries           → 🎯 @engineer:backend
find authentication implementation  → 🎯 @researcher:codebase

# 完成后退出
/exit
```

**优势：**
- ✅ 无需每次都输入 `/squad`
- ✅ 自然的对话流程
- ✅ 非常适合长时间开发会话

#### ⚡ 单次执行模式

适用于快速的一次性任务：

```bash
/squad fix login button             → 执行一次后退出
/squad @engineer:backend optimize   → 手动选择智能体
```

---

## 团队成员

### 🔍 研究员 (Researcher) / 研究员
**模型：** Haiku（高性价比）

探索代码库，搜索文件，理解架构。

**标签：**
- `codebase`（默认）- 一般代码探索
- `documentation` - 查找和阅读文档

**示例：**
```bash
/squad find authentication implementation
/squad @researcher:documentation locate API reference
```

---

### 💻 工程师 (Engineer) / 工程师
**模型：** Sonnet（平衡）/ Opus（复杂任务）

实现功能，修复 bug，编写代码。

**标签：**
- `fullstack`（默认）- 一般实现
- `frontend` - UI/UX，组件，样式
- `backend` - API，数据库，服务器逻辑

**示例：**
```bash
/squad fix login button
/squad @engineer:frontend add dark mode
/squad @engineer:backend optimize database queries
```

---

### ✅ 测试员 (Tester) / 测试员
**模型：** Haiku（高性价比）

运行测试，验证结果，检查构建。

**标签：**
- `unit`（默认）- 单元测试
- `integration` - 集成测试
- `e2e` - 端到端测试

**示例：**
```bash
/squad run tests
/squad @tester:unit verify login tests
/squad @tester:e2e test checkout flow
```

---

## 🎯 路由系统

### 路由工作原理

Squad 分析你的任务描述并将其路由到适当的智能体：

```
任务: "fix login button"
  ↓
检测到的关键词: [button, login, fix]
  ↓
匹配: frontend (button → UI 工作)
  ↓
路由: Engineer:frontend  🎯
  ↓
使用前端特定指令执行
```

### 路由可见性

**每个任务都会显示路由决策：**

```bash
/squad fix login button
🎯 @engineer:frontend

/squad optimize database query
🎯 @engineer:backend

/squad find auth code
🎯 @researcher:codebase
```

**详细模式 (verbose mode)** 显示详细分析：

```bash
/squad --verbose fix login button

🎯 Squad 路由分析
   任务关键词: [button, login, fix]
   匹配模式: frontend
   置信度: 高

→ @engineer:frontend
```

### 自动路由 vs 手动路由

**自动路由（推荐）：**
```bash
/squad fix login button
→ 自动检测：Engineer:frontend
```

**手动路由（精确控制）：**
```bash
/squad @engineer:frontend add dark mode
→ 强制：Engineer:frontend
```

---

## 📋 命令参考

### `/squad` - 进入持久化模式
```bash
/squad
```
进入持久化模式，所有消息都会自动路由。

### `/squad [任务]` - 单次执行
```bash
/squad fix login button
```
执行一个任务后退出。

### `/squad config` - 配置向导
```bash
/squad config
```
交互式向导，用于配置语言和权限级别。

### `/squad reflect` - 性能分析
```bash
/squad reflect
/squad 回顾  # 中文别名
```
分析对话性能并提出改进建议。

### `/squad rollback` - 撤销变更
```bash
/squad rollback <session_id>
/squad rollback last
```
回滚进化变更。

### `/squad --verbose` - 显示路由详情
```bash
/squad --verbose [任务]
```
显示详细的路由分析。

### `/squad --help` - 显示帮助
```bash
/squad --help
```
显示完整的帮助信息。

### `/squad set-lang` - 切换语言
```bash
/squad set-lang zh    # 切换到中文
/squad set-lang en    # 切换到英文
```

### `/exit` - 退出持久化模式
```bash
/exit
/quit
/squad exit
```
退出 Squad 持久化模式。

---

## ⚙️ 配置

### 语言设置

通过向导配置：
```bash
/squad config
```

或手动编辑 `~/.squad/config.yaml`：
```yaml
language: zh  # en | zh
```

### 权限级别

#### 🛡️ 保守模式 (Conservative) / 保守
**理念：** 安全第一，手动控制

**行为：**
- ✋ 创建任何文件前询问
- ✋ 编辑任何文件前询问
- ✋ 所有命令前询问
- ✋ Git 操作前询问
- ✅ 自动允许：Read、Glob、Grep

**适用于：**
- 学习 Squad
- 关键项目
- 严格的变更管理

---

#### ⚖️ 平衡模式 (Balanced) / 平衡 - **推荐**
**理念：** 信任但验证关键操作

**行为：**
- ✅ 自动允许：创建/编辑文件、运行测试、git commit
- ✋ 以下操作前询问：删除文件、git push、破坏性命令
- ✋ 以下操作前询问：配置变更

**适用于：**
- 日常开发
- 大多数项目
- 平衡速度和安全性

---

#### 🚀 自主模式 (Autonomous) / 自主
**理念：** 完全自动化，最小中断

**行为：**
- ✅ 自动允许：所有操作
- ⚠️ 日志记录：所有操作都会记录
- 🛟 安全网：破坏性操作前自动备份

**适用于：**
- 长时间运行的项目（24 小时以上）
- 原型开发
- 可信任的自动化
- 个人项目

**⚠️ 警告：** 谨慎使用。需要高度信任。

---

### 路由器自定义

编辑 `~/.squad/router.yaml` 来自定义路由：

```yaml
engineer:
  frontend:
    keywords: [ui, button, page, component, style, css, react, vue]
  backend:
    keywords: [api, database, query, server, endpoint, sql, auth]
  fullstack:
    default: true
```

**可扩展：** 添加你自己的关键词、模式和规则。

---

## 设计理念

### 1. Token 效率优先
- **串行执行**而非并行
- **智能路由**以最小化开销
- **轻量级智能体**（尽可能使用 Haiku）

### 2. 渐进式复杂度
- 从 **3 个简单智能体**开始
- 添加标签而非新智能体
- 需要时再扩展，不要提前

### 3. 清晰胜于魔法
- **可见的路由决策**
- **清晰的智能体边界**
- **可理解的规则**

### 4. 实用胜于完美
- **关键词匹配**足以应对 90% 的情况
- 需要时使用**模式匹配**
- 真正需要时才使用 **ML 分类**

---

## 对比

### vs. 并行多智能体系统（例如 Wukong）

| 特性 | 并行系统 | Squad |
|---------|------------------|-------|
| **执行方式** | 多个智能体并行 | 一次一个智能体（串行） |
| **Token 成本** | 高（10+ 个智能体运行） | 低（每步 1 个智能体） |
| **速度** | 快（并发） | 中等（顺序） |
| **复杂度** | 高（协调、状态） | 低（简单路由） |
| **最适合** | 复杂工作流、研究 | 开发任务、成本敏感 |

**简而言之：** Squad 以一些速度换取显著的成本节省和简洁性。

---

## 示例

### 示例 1：修复 Bug

```bash
/squad fix the login button not responding

🎯 @engineer:frontend

[智能体分析问题]
[定位按钮组件]
[识别事件处理程序问题]
[修复代码]
[测试修复]

✅ 已修复：LoginButton.tsx 中缺少 onClick 处理程序
```

### 示例 2：探索代码库

```bash
/squad find where user authentication is implemented

🎯 @researcher:codebase

[智能体搜索认证相关文件]
[读取关键实现]
[追踪依赖关系]

📋 在以下位置找到身份验证：
  - src/auth/login.ts:42 (主逻辑)
  - src/middleware/auth.ts:15 (中间件)
  - src/api/auth.ts:23 (API 端点)
```

### 示例 3：运行测试

```bash
/squad verify all tests pass

🎯 @tester:unit

[智能体运行测试套件]
[解析结果]
[报告状态]

✅ 测试结果：
  - 总计：42 个测试
  - 通过：42 ✅
  - 失败：0
  - 构建：✅ 成功
```

### 示例 4：持久化模式工作流

```bash
# 进入持久化模式
/squad

# 自然地处理多个任务
fix login button              → 🎯 @engineer:frontend
optimize database queries     → 🎯 @engineer:backend
run all tests                 → 🎯 @tester:unit
find API documentation        → 🎯 @researcher:documentation

# 完成后退出
/exit
```

---

## 路线图 (Roadmap)

### v0.1.0 (MVP) ✅
- [x] 3 个核心智能体（研究员、工程师、测试员）
- [x] 专业化标签系统
- [x] 基于关键词的路由
- [x] 双语支持（中/英）
- [x] 串行执行

### v0.2.0 (增强用户体验) ✅
- [x] 持久化模式
- [x] 路由可见性（🎯 显示）
- [x] 配置向导
- [x] 权限级别（3 种模式）
- [x] 反思与进化系统

### v0.3.0 (高级路由)
- [ ] 模式匹配（正则表达式）
- [ ] 置信度评分
- [ ] 低置信度时用户确认
- [ ] 路由分析

### v0.4.0 (更多智能体)
- [ ] 架构师智能体（系统设计）
- [ ] 审查员智能体（代码审查）
- [ ] 安全专家
- [ ] 性能优化器

### v0.5.0 (高级功能)
- [ ] 多智能体工作流（串行链）
- [ ] 上下文持久化
- [ ] 从纠正中学习
- [ ] 项目特定路由

详见 [ROADMAP.md](ROADMAP.md)。

---

## 项目结构

```
squad/
├── README.md                    # 英文文档
├── README.zh.md                 # 中文文档
├── ROADMAP.md                   # 功能路线图
├── CLAUDE.md                    # 开发者指南（面向 Claude）
├── LICENSE                      # MIT 许可证
├── install.sh                   # 安装脚本
│
├── squad-dist/                  # 源文件
│   ├── rules/
│   │   └── 00-squad-core.md    # 核心规则（由 Claude Code 自动加载）
│   │
│   ├── agents/                  # 智能体定义
│   │   ├── researcher.md       # 研究员智能体
│   │   ├── engineer.md         # 工程师智能体
│   │   └── tester.md           # 测试员智能体
│   │
│   ├── commands/                # 命令实现
│   │   ├── squad.md            # /squad 命令
│   │   ├── config.md           # /squad config
│   │   ├── reflect.md          # /squad reflect
│   │   └── exit.md             # 退出命令
│   │
│   ├── skills/                  # 技能
│   │   └── translate.md        # 翻译技能
│   │
│   └── router/
│       └── router.yaml         # 路由规则（可扩展）
│
└── tests/                       # 测试（即将推出）
    └── test_router.py
```

**安装后：**

```
~/.claude/
├── rules/00-squad-core.md      # 由 Claude Code 自动加载
├── agents/                      # 可供 Task 工具使用
│   ├── researcher.md
│   ├── engineer.md
│   └── tester.md
├── commands/                    # Squad 命令
│   ├── squad.md
│   ├── config.md
│   ├── reflect.md
│   └── exit.md
└── skills/                      # Squad 技能
    └── translate.md

~/.squad/
├── config.yaml                  # 用户配置
├── router.yaml                  # 路由规则
├── session.yaml                 # 持久化模式会话
├── evolution/                   # 进化日志
├── backups/                     # 备份文件
└── logs/                        # 操作日志（自主模式）
```

---

## 常见问题 (FAQ)

### 为什么不直接使用 Claude？

当然可以！Squad 适用于以下情况：
- **专业化行为**（前端 vs 后端）
- **一致的质量**（专门用于测试的智能体）
- **更好的组织**（清晰的关注点分离）
- **路由可见性**（查看决策过程）

### 为什么是串行而非并行？

**Token 效率。** 并行运行 5 个智能体会消耗 5 倍的 token。对于大多数开发任务，串行执行足够快且成本更低。

### 如何知道哪个智能体处理了我的任务？

Squad 在执行前会用 🎯 显示路由决策：
```
🎯 @engineer:frontend
```

### 我可以自定义路由规则吗？

可以！编辑 `~/.squad/router.yaml` 来添加关键词、模式和权重。

### 模式之间有什么区别？

- **持久化模式** - 停留在 Squad 中，所有消息自动路由（推荐）
- **单次执行模式** - 运行一个任务后退出

### 权限系统如何工作？

在 `/squad config` 中选择一个权限级别：
- **保守模式** - 每个操作前都询问
- **平衡模式** - 自动允许常见操作，关键操作需确认（推荐）
- **自主模式** - 适用于长任务的完全自动化

### Squad 可以自我改进吗？

可以！使用 `/squad reflect` 分析性能并应用改进。使用 `/squad rollback` 撤销变更。

### 我可以添加自己的智能体吗？

可以！详见 [CLAUDE.md](CLAUDE.md) 开发者指南。

### 它能与其他 Claude Code 工具一起使用吗？

可以！Squad 只是一个命令和一些智能体。可以与其他技能和命令一起使用。

### Squad 支持多语言吗？

是的！完整的中英文支持。使用 `/squad config` 或 `/squad set-lang` 切换。

---

## 贡献

欢迎贡献！请：

1. Fork 仓库
2. 创建功能分支
3. 进行更改
4. 添加测试（可用时）
5. 提交 PR

---

## 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)。

---

## 灵感来源

Squad 的灵感来自：
- **Wukong** - 多智能体编排概念
- **敏捷团队** - 专业角色协同工作
- **Unix 哲学** - 专注做好一件事，组合工具

---

## 支持

- **问题：** [GitHub Issues](https://github.com/yourusername/squad/issues)
- **讨论：** [GitHub Discussions](https://github.com/yourusername/squad/discussions)
- **文档：** 安装后查看 `~/.squad/`

---

<p align="center">
  <b>智能路由 · 串行执行 · Token 高效</b><br>
  为关心成本的 Claude Code 开发者打造
</p>
