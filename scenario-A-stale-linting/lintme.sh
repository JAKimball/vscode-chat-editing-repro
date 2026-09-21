#!/usr/bin/env bash
# Scenario A seed file: six distinct, unambiguous ShellCheck violations
# (SC2005 accompanies SC2046). The repro asks Copilot to fix ONLY SC2086
# and SC2034, leaving the other violations in place so stale-vs-real
# diagnostics are distinguishable after session resume.

# SC2086: unquoted variable (word splitting). The value contains a space so
# ShellCheck cannot prove it is a single word — SC2086 does not fire on
# provably-single-word variables.
count="5 6"
echo Processing $count items

# SC2034: unused variable
unused_backup_dir="/var/backup"

# SC2046: unquoted command substitution (word splitting)
# (SC2005 also fires here: "useless echo" — harmless for the repro)
echo $(date)

# SC2155: mask return value of command substitution in a declaration
export LOGFILE=$(mktemp)

# SC2181: checking $? instead of using if directly
grep -q "root" /etc/passwd
if [ "$?" -eq 0 ]; then
    echo "found root"
fi
