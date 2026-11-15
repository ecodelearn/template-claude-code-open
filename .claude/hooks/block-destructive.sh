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

# Secret-file reads through the shell (permissions.deny only covers the Read tool)
SECRET_RE='(cat|less|more|head|tail|grep|rg|sed|awk|cp|mv|base64|xxd|strings|source|\.)[[:space:]]+[^|;&]*(\.env([^a-zA-Z0-9_-]|$)|\.env\.[a-zA-Z0-9_.-]+|\.pem([^a-zA-Z0-9_]|$)|id_rsa|id_ed25519)'
if echo "$COMMAND" | grep -Eq "$SECRET_RE" && ! echo "$COMMAND" | grep -Eq '\.env\.(example|sample|template)'; then
    jq -n \
        --arg reason "Reading a secret file (.env, key, pem) through the shell is blocked. Ask the user to provide the needed value." \
        '{
            hookSpecificOutput: {
                hookEventName: "PreToolUse",
                permissionDecision: "deny",
                permissionDecisionReason: $reason
            }
        }'
    exit 0
fi

exit 0
