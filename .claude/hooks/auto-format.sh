#!/usr/bin/env bash
# Hook: PostToolUse — Auto-formats file after edits
# Receives JSON via stdin: {"tool_name": "Edit|Write", "tool_input": {"file_path": "..."}}
# Detects available formatter based on file extension

INPUT=$(cat)

TOOL=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_name', ''))
except:
    print('')
" 2>/dev/null)

# Only runs after file edits
[[ "$TOOL" != "Edit" && "$TOOL" != "Write" ]] && exit 0

FILE=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    inp = d.get('tool_input', {})
    print(inp.get('file_path', '') or inp.get('new_file_path', ''))
except:
    print('')
" 2>/dev/null)

[[ -z "$FILE" || ! -f "$FILE" ]] && exit 0

EXT="${FILE##*.}"

case "$EXT" in
    js|jsx|ts|tsx|json|css|scss|html|md|yaml|yml)
        command -v prettier &>/dev/null && prettier --write "$FILE" --log-level silent 2>/dev/null
        ;;
    py)
        if command -v ruff &>/dev/null; then
            ruff format "$FILE" 2>/dev/null
        elif command -v black &>/dev/null; then
            black "$FILE" --quiet 2>/dev/null
        fi
        ;;
    go)
        command -v gofmt &>/dev/null && gofmt -w "$FILE" 2>/dev/null
        ;;
    rs)
        command -v rustfmt &>/dev/null && rustfmt "$FILE" 2>/dev/null
        ;;
    sh|bash)
        command -v shfmt &>/dev/null && shfmt -w "$FILE" 2>/dev/null
        ;;
esac

exit 0
