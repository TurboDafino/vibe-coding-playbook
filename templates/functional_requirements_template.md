# 功能需求文档（Functional Requirements）模板

> 用法：复制到你的项目。这是"施工图纸"的具体形态——**需求要写到 AI 可以直接执行的深度**。
> 每个字段旁边都标注了"为什么存在、不写会发生什么事故"，填写时把注释删掉即可。
>
> 配套关系：本文件管"做什么、做到什么深度"；`project_spec_template.md` 管"项目全貌与目录锚"；
> `EXECUTION_PROTOCOL.md` 管"一步步怎么执行"；`development_guidelines.md` 管"红线与检查"。

## 写作原则

1. **写到可测试的深度**：每个 Phase 的 Detailed Logic 用编号步骤，写完人能逐步验收、AI 能逐步实现
2. **一个 Phase 一个验收点**：每个 Phase 都要能独立回答"做到什么样算完"
3. **状态字段驱动进度**：`Status: Pending / In Progress / Done`，AI 交接班时靠它定位"干到哪了"
4. **跨文件引用用编号**：引用规范文件时用 `[x.y]` 编号（如"遵循 [7.3]"），不写大段重复内容——规矩只有一份真相源
5. **严禁行话黑话**：业务术语写全称，AI 不懂你的行业缩写

---

## 骨架

```markdown
# Project: <项目代号>

# Functional Requirements (功能需求文档)

## Module <N>: <模块名>

### Phase <N.N>: <阶段名>
* **Priority:** Critical (P0) / High (P1) / Medium (P2)
* **Status:** Pending
* **Feature Name:** <动词短语，如 Fetch & Save Orders>
* **User Story:** 作为<角色>，我希望<能力>，以便<价值>
* **Detailed Logic:**
    1. **Trigger:** <谁、在哪个界面、点什么，触发本功能>
    2. **Input:** <输入参数与校验规则>
    3. **Processing:** <处理步骤，每步一句话；涉及外部系统时写明失败怎么办>
    4. **Storage:** <写什么表/文件，已存在时怎么办（去重策略）>
    5. **Response:** <返回给调用方的结构，成功/失败各长什么样>
* **Acceptance:** <验收方式：跑哪个检查脚本 / 打开哪个页面看到什么>
```

---

## 字段注解（为什么这么设计）

| 字段 | 为什么存在 | 不写会发生什么 |
|------|-----------|---------------|
| Priority | AI 默认"什么都重要"，排期靠它砍需求 | 低价值功能插队，核心功能烂尾 |
| Status | AI 没有记忆，靠它判断"这步干没干" | 重复施工，或跳过未完成的阶段 |
| User Story | 给 AI"为什么"，它才能在模糊处做对选择 | AI 只实现字面功能，边界情况全错 |
| Trigger 精确到按钮 | AI 需要知道功能的入口在哪 | 功能写完了但"挂不上"界面，返工 |
| Storage 去重策略 | 采集/导入类功能的重灾区 | 重复数据污染库，事后清洗代价大 |
| Response 结构 | 前后端联调的合同 | 前端解析报错，互相甩锅 |
| Acceptance | "做到什么样算完"的客观标准 | AI 自说自话"已完成"，实际没验收 |

---

## 一个填好的示例（虚构业务）

```markdown
## Module 1: Data Collection (数据采集模块)

### Phase 1.1: Order List Collection (订单列表采集)
* **Priority:** High (P1)
* **Status:** Pending
* **Feature Name:** Fetch & Save Orders
* **User Story:** 作为运营分析员，我希望一键获取某平台的近期订单列表，以便分析销售动向。
* **Detailed Logic:**
    1. **Trigger:** 用户在前端选择目标平台，点击"开始采集"。
    2. **Routing:** 后端加载对应平台的配置文件（遵循 [7.3]，严禁硬编码平台专属逻辑）。
    3. **Fetching:** 请求配置中的列表接口，带分页参数，循环采到"无新数据"为止。
    4. **Parsing:** 按配置的选择器提取字段：order_name / order_url / created_at / amount。
    5. **Deduplication:** 以 order_code 为唯一键查库，已存在则跳过并记日志。
    6. **Storage:** 分页写入——每采完一页立即写库，失败只影响当前页。
    7. **Response:** 返回 `{ success: 10, skipped: 2, message: "..." }`。
* **Acceptance:** 运行 `tests/stepN_collect_test.py` 全部断言通过；前端列表页能看到新采集的记录。
```

> 注意示例里的细节：去重键、分页写入、响应结构、验收脚本名——**这些就是"写到可执行深度"的意思**。
> 如果你的需求里出现"采集订单数据"这种一句话描述，AI 一定会用最偷懒的方式实现它。
