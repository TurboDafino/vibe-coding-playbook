#!/usr/bin/env bash
# sync-out.sh —— 发送端（下班的电脑）：把近期改动打成单文件"包裹"
# 用法：
#   ./sync-out.sh              打最近 2 天的增量包裹（日常）
#   ./sync-out.sh --full       打全量包裹（每周冷备 / 分叉应急）
# 生成文件通过任意文件传输方式发给另一端即可。传坏了重传，绝不损坏两端仓库。

set -euo pipefail

if [ "${1:-}" = "--full" ]; then
  OUT="full-$(date +%F-%H%M).bundle"
  git bundle create "$OUT" --all
  echo "✅ 已生成全量包裹：$OUT"
else
  SINCE="${1:-2 days ago}"
  OUT="sync-$(date +%F-%H%M).bundle"
  git bundle create "$OUT" --since="$SINCE" --branches
  echo "✅ 已生成增量包裹：$OUT（起点：$SINCE）"
fi

echo "📦 请把该文件发给另一端，接收端用 sync-in.sh 接收"
