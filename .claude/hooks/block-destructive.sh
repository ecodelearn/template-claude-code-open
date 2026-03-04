#!/usr/bin/env bash
# Hook: PreToolUse — Blocks destructive commands before execution
# Receives JSON via stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}}

INPUT=$(cat)

TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
[[ "$TOOL" != "Bash" ]] && exit 0

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
[[ -z "$COMMAND" ]] && exit 0

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
        jq -n \
            --arg reason "Dangerous command blocked: '$pattern'. If truly necessary, run it manually in the terminal." \
            '{
                hookSpecificOutput: {
                    hookEventName: "PreToolUse",
                    permissionDecision: "deny",
                    permissionDecisionReason: $reason
                }
            }'
        exit 0
    fi
done

exit 0
