# Vibe Coding Playbook

**用自然语言指挥 AI 做项目的实战手册**——来自一个真实项目的沉淀：约 17 天、87 次提交、8239 行代码、195 条自动检查断言，作者几乎没写过一行代码。

> 不懂代码也能用。本手册的核心不是代码，而是**如何管理一个"会写代码，但没有判断力、没有记性、爱走捷径"的 AI**：人管方向和验收，AI 管执行，中间靠"写下来的规矩"协作。

**本仓库双地址托管（内容一致）**：Gitee（国内推荐）：https://gitee.com/dafino/vibe-coding-playbook ｜ GitHub 镜像：https://github.com/TurboDafino/vibe-coding-playbook

---

## 三条经验（30 秒版）

1. **规矩要写下来、能检查**——AI 没有记性，口头说的规矩等于没有。写进文件，最好配自动检查，让它每次开工前先读。
2. **验收要看真东西**——AI 说"成功了"不算数。打开页面看一眼、查一下数据，才算完。它报的"成功"和你看到的"能用"，中间可能隔着好几个隐藏 bug。
3. **踩坑就立规矩**——每踩一个坑，就写一条"下次不许"。坑不是损失，是免费的经验包，前提是你把它存下来。

## 可以直接抄走的六件事

以下六件事**完全不需要懂代码**，明天就能用：

| # | 做法 | 一句话说明 |
|---|------|-----------|
| 1 | **给 AI 一份"施工图纸"** | 开工前把项目拆成若干步，每步写清"做什么、做到什么样算完"，让 AI 按步走、不许跳步 |
| 2 | **确认制：动手前先报方案** | 让 AI 先说"改哪几个文件、怎么改、为什么"，你点头它才动手 |
| 3 | **每步完工要"拍照留证"** | 让 AI 每步做完自动跑检查并留一份记录。它说"做完了"不算，检查通过才算 |
| 4 | **让 AI 每天写工作日志** | 当天改了什么、为什么、结果如何。AI 记不住昨天，日志就是它的"交接班记录" |
| 5 | **验收看真东西** | 页面打开看一眼、数据查一下，别只听 AI 汇报"成功了" |
| 6 | **下班前三件事** | 关程序、清临时文件、清缓存。AI 不会自己"下班收拾工位"，要明文规定 |

## 仓库地图

| 位置 | 内容 | 适合谁 |
|------|------|--------|
| [playbook/vibe-coding-playbook.md](playbook/vibe-coding-playbook.md) | **完整操作手册**：十条红线、交接班模板、收尾 SOP、验收清单、多端同步 | 所有人，主文档 |
| [case-study/project-retrospective.md](case-study/project-retrospective.md) | **脱敏复盘全文**：踩坑实录、制度演进、架构迭代 | 想了解来龙去脉的人 |
| [templates/NEW_SESSION_BRIEF.md](templates/NEW_SESSION_BRIEF.md) | 交接班文件模板 | 马上开工的人 |
| [templates/EXECUTION_PROTOCOL.md](templates/EXECUTION_PROTOCOL.md) | 施工图纸（执行协议）模板 | 马上开工的人 |
| [templates/development_guidelines.md](templates/development_guidelines.md) | 规范文件骨架（十条红线已预填） | 马上开工的人 |
| [templates/snapshot_template.json](templates/snapshot_template.json) | 完工快照格式 | 配套使用 |
| [templates/session_checkout_checklist.md](templates/session_checkout_checklist.md) | 下班前三件事清单 | 配套使用 |
| [templates/sync/](templates/sync/) | 两台电脑同步脚本（sync-out / sync-in） | 多端开发者 |

## 快速开始（5 分钟）

1. 把 `templates/NEW_SESSION_BRIEF.md` 复制到你的项目根目录
2. 把 `templates/development_guidelines.md` 复制过去——十条红线已预填，之后每踩一个坑按格式追加
3. 把 `templates/EXECUTION_PROTOCOL.md` 复制过去，和 AI 一起把你的项目拆成 Step 填进表里
4. 每次新开 AI 对话，第一句话：**"先读 NEW_SESSION_BRIEF.md，按流程来。"**

## 适用人群

- **完全不懂代码、但业务目标明确的人**（主要对象）：你不需要会写代码，需要会判断"方案对不对、结果是不是真的"
- 代码和业务都在摸索的人：方法论帮你少踩坑
- 懂代码、想建立 AI 协作规范的人：直接拿红线和模板去用

## 真实性与脱敏声明

本仓库内容提炼自一个真实软件项目（2026 年 7 月，约 17 天）。**行业类型、目标站点、业务数据均已脱敏**；工程指标（87 次提交 / 8239 行 / 195 条断言 / 29 章 884 行规范）、事故机理、方法论均为真实记录，各数字之间可交叉验证。脱敏细节见复盘全文附录。

开发工具（比例为内部估算）：Kimi 约 70%（其中 K2.6 约九成、K2.7 约一成）、GLM 5.2 约 20%、Qwen 3.7 Max 约 10%；复盘文档由 Kimi K3 生成。

## License

[MIT](LICENSE)——随意使用、修改、再分发，保留出处即可。

---

如果这份手册帮到你，欢迎 Star；如果你也踩了新的坑、立了新的规矩，欢迎提 Issue 分享给大家。
