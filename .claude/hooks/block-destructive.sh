#!/usr/bin/env bash
# Hook: PreToolUse — Blocks destructive commands before execution
# Receives JSON via stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}}

INPUT=$(cat)

deny() {
    # Plain printf so the hook still blocks when jq is not installed.
    printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
    exit 0
}

# Parse the command with jq, then python3. With neither available, match the
# patterns against the raw JSON instead of letting everything through.
if command -v jq &>/dev/null; then
    TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
    COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)
elif command -v python3 &>/dev/null; then
    TOOL=$(printf '%s' "$INPUT" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_name",""))' 2>/dev/null)
    COMMAND=$(printf '%s' "$INPUT" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("tool_input",{}).get("command",""))' 2>/dev/null)
else
    TOOL="Bash"
    COMMAND="$INPUT"
fi

[[ "$TOOL" != "Bash" ]] && exit 0
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
    if printf '%s' "$COMMAND" | grep -qiF -- "$pattern"; then
        deny "Dangerous command blocked: '$pattern'. If truly necessary, run it manually in the terminal."
    fi
done

# Secret-file reads through the shell (permissions.deny only covers the Read tool).
# Best-effort guard against mistakes, not a security boundary: interpreters,
# variables and copies can still read these files.
# Example/sample/template env files and public keys are fine to read.
CHECK=$(printf '%s' "$COMMAND" | sed -E 's/\.env\.(example|sample|template)//g; s/id_(rsa|ed25519)[A-Za-z0-9_-]*\.pub//g')
READERS='(cat|less|more|head|tail|grep|rg|sed|awk|base64|xxd|strings|source|\.)'
SEP="[[:space:]/\"'=<]"
END="(\$|[[:space:]\"'|;&>)\\])"
SECRET="(\.env(\.[A-Za-z0-9_.-]+)?${END}|[A-Za-z0-9_.-]*\.pem${END}|id_rsa|id_ed25519)"
if printf '%s' "$CHECK" | grep -Eq "(^|[[:space:];&|(\"])${READERS}[[:space:]]+([^|;&]*${SEP})?${SECRET}"; then
    deny "Reading a secret file (.env, key, pem) through the shell is blocked. Ask the user to provide the needed value."
fi

exit 0
