#!/usr/bin/env bash
# sync-in.sh —— 接收端（上班的电脑）：校验 + 拉取 + 提示合并
# 用法：
#   ./sync-in.sh <包裹文件>
#
# 如果校验报 "Repository lacks these prerequisite commits"：
#   说明两端历史已分叉，增量包裹解不开。
#   处置口诀：别猜、打全量、看清再合 ——
#   让历史较全的一端用 sync-out.sh --full 重打全量包裹，再用本脚本接收。

set -euo pipefail

BUNDLE="${1:?用法: ./sync-in.sh <包裹文件>}"

echo "① 校验包裹完整性……"
git bundle verify "$BUNDLE"

echo "② 拉取包裹内容……"
git fetch "$BUNDLE"

echo "✅ 拉取完成。请先查看对方历史："
echo "   git log --oneline --graph FETCH_HEAD | head -30"
echo "确认无误后合并："
echo "   git merge FETCH_HEAD"
