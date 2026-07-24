#!/bin/bash
# ============================================================
# sync-out.sh — 离开这台电脑前，在"项目根目录"运行（A 端用）
#
# 用法：bash sync-out.sh          # 只打包改动文件（增量模式，默认）
#       bash sync-out.sh --kill   # 先杀掉占用端口的进程，再打包
#       bash sync-out.sh --full   # 全量打包（排除依赖和缓存）
#
# 打包即收尾：打包前自动执行"下班三件事"（端口检测 → tests/tmp
# 临时产物 → .vite 残留），并自检"改动的文件是否都是白名单内的"。
# 配一个同目录白名单 .sync-whitelist，改动文件不在名单内会直接
# 拒绝打包并提示你"是不是忘记走 sync 了"。
# ============================================================

set -euo pipefail
cd "$(dirname "$0")"

TS=$(date +%Y-%m-%d_%H%M%S)
BUNDLE="sync_bundle_${TS}.zip"

# 打包时需要排除的依赖和缓存目录（永远不打）
EXCLUDES="-x node_modules/\* dist/\* .venv/\* venv/\* __pycache__/\* .git/\* *.log .DS_Store"

# 收尾自检要检测的端口（⚠️ 改成你项目的实际端口，空格分隔）
PORTS="5555 5173"

# 仓库里要提前建好的"说明文件夹"占位文件（如果丢了自动重建）
KEEP_FILES=("docs/handoff/README_KEEP.md" "docs/reports/README_KEEP.md")

# ---------- 参数解析 ----------
KILL_PORTS=false
FULL_MODE=false
for arg in "$@"; do
    [ "$arg" = "--kill" ] && KILL_PORTS=true
    [ "$arg" = "--full" ] && FULL_MODE=true
done

echo "=== sync-out 收尾自检（改动文件 → ${BUNDLE}）==="

# ---------- 0. git 环境自检 ----------
git rev-parse --is-inside-work-tree > /dev/null 2>&1 || {
    echo "❌ 当前目录不在 git 仓库里"; exit 1;
}
git ls-files --error-unmatch .sync-whitelist > /dev/null 2>&1 || {
    echo "❌ .sync-whitelist 未被 git 跟踪，请先提交白名单"; exit 1;
}

# ---------- 1. 收尾①：端口检测 ----------
echo "[收尾①] 端口检测（${PORTS}）..."
PORT_BUSY=false
for port in ${PORTS}; do
    PIDS=""
    if command -v lsof > /dev/null 2>&1; then
        PIDS=$(lsof -ti :"$port" 2>/dev/null || true)
    elif command -v netstat > /dev/null 2>&1; then
        PIDS=$(netstat -ano 2>/dev/null | grep -E "[:.]${port}[[:space:]]" | grep LISTEN | awk '{print $NF}' | sort -u || true)
    fi
    if [ -n "$PIDS" ]; then
        if [ "$KILL_PORTS" = true ]; then
            echo "$PIDS" | xargs kill 2>/dev/null || true
            echo "  ✅ 端口 ${port} 残留进程已关闭（PID: $PIDS）"
        else
            echo "  ⚠️  端口 ${port} 仍被占用（PID: $PIDS）——用 --kill 自动关闭"
            PORT_BUSY=true
        fi
    else
        echo "  ✅ 端口 ${port} 无占用"
    fi
done
if [ "$PORT_BUSY" = true ]; then
    echo "❌ 有端口仍被占用。请先手动关闭服务，或用 bash sync-out.sh --kill 重试"
    exit 1
fi

# ---------- 2. 收尾②：tests/ 与 tmp/ 临时产物 ----------
echo "[收尾②] tests/ 与 tmp/ 临时产物检测..."
if [ -d tests ] && [ -n "$(ls -A tests 2>/dev/null || true)" ]; then
    echo "  ⚠️  tests/ 目录非空：$(ls -A tests | tr '\n' ' ') —— 请确认无需保留后删除"
else
    echo "  ✅ tests/ 无残留"
fi
if [ -d tmp ] && [ -n "$(ls -A tmp 2>/dev/null || true)" ]; then
    echo "  ⚠️  tmp/ 目录非空：$(ls -A tmp | tr '\n' ' ') —— 请确认无需保留后删除"
else
    echo "  ✅ tmp/ 无残留"
fi

# ---------- 3. 收尾③：.vite 残留 ----------
echo "[收尾③] .vite 残留检测..."
if ls -d .vite deps_temp_* 2>/dev/null | grep -q .; then
    ls -d .vite deps_temp_* 2>/dev/null | xargs rm -rf
    echo "  ✅ 已清理 .vite / deps_temp_* 残留"
else
    echo "  ✅ 无 .vite 残留"
fi

# ---------- 4. 找出改动文件（白名单交集，排除白名单自身）----------
# whitelist 用 blob:none 部分克隆也能本地读，所以直接 git show
ALL_CHANGED=$(git status --porcelain | awk '{print $2}')
CHANGED=$(git show HEAD:.sync-whitelist \
    | grep -v '^#' | grep -v '^$' \
    | grep -vx '.sync-whitelist' \
    | grep -Ff - <(echo "$ALL_CHANGED") || true)

if [ -z "$CHANGED" ]; then
    echo ""
    echo "ℹ️  白名单内的文件都没有改动（若 .sync-whitelist 自身有更新，请先提交后再打包）"
    exit 0
fi

# ---------- 5. 收尾自检：改动的文件是否都是"该同步的" ----------
MISSING=$(echo "$ALL_CHANGED" | grep -Ff <(git show HEAD:.sync-whitelist | grep -v '^#' | grep -v '^$') -v || true)
if [ -n "$MISSING" ]; then
    echo ""
    echo "⚠️  以下改动文件不在白名单内（是不是忘记走 sync 了）："
    echo "$MISSING" | sed 's/^/   - /'
    echo "请先把它们移入白名单路径（或确认不需要同步）后再打包"
    exit 1
fi

echo ""
echo "收尾自检通过，将打包以下文件："
echo "$CHANGED" | sed 's/^/   - /'
echo ""

# ---------- 6. 确保说明文件夹占位文件存在 ----------
for f in "${KEEP_FILES[@]}"; do
    mkdir -p "$(dirname "$f")"
    [ -f "$f" ] || echo "# 这个文件夹是约定共享空间，请勿删除" > "$f"
done

# ---------- 7. 打包 ----------
echo "$CHANGED" | tr '\n' '\0' | xargs -0 zip -q "$BUNDLE"

# 全量模式：额外打一个完整包裹（排掉依赖缓存，可直接用于冷启动）
if [ "$FULL_MODE" = true ]; then
    FULL_BUNDLE="sync_bundle_full_${TS}.zip"
    zip -q -r "$FULL_BUNDLE" . $EXCLUDES
    echo "📦 全量包裹：${FULL_BUNDLE}（$(du -h "$FULL_BUNDLE" | cut -f1)）"
fi

echo "📦 收尾完成。请把包裹文件发给另一端，接收端用 sync-in.sh 接收"
