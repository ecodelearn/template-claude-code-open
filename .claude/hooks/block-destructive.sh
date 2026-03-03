#!/usr/bin/env bash
# Hook: PreToolUse — Blocks destructive commands before execution
# Receives JSON via stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}}

INPUT=$(cat)

TOOL=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_name', ''))
except:
    print('')
" 2>/dev/null)

# Only inspect Bash tool
[[ "$TOOL" != "Bash" ]] && exit 0

COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get('tool_input', {}).get('command', ''))
except:
    print('')
" 2>/dev/null)

# Blocked patterns
BLOCKED=(
    "rm -rf"
    "rm -fr"
    "git push --force"
    "git push -f "
    "git reset --hard"
    "DROP TABLE"
    "DROP DATABASE"
    "TRUNCATE TABLE"
    "chmod -R 777"
    "mkfs"
    "dd if="
)

for pattern in "${BLOCKED[@]}"; do
    if echo "$COMMAND" | grep -qi "$pattern"; then
        echo "[BLOCKED] Dangerous command detected: '$pattern'"
        echo "If truly necessary, run it manually in the terminal."
        exit 2
    fi
done

exit 0
