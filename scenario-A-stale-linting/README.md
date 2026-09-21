# Scenario A — Stale linting of rehydrated chat-editing documents

**Defect:** After resuming a past Copilot Chat editing session, the Problems
panel repopulates with diagnostics for issues that were already fixed and
committed. Clicking an entry opens a tab showing the **stale snapshot** of
the file — visually indistinguishable from a live file tab.

**Upstream issue draft:** `issue-draft-A-stale-linting.md` (microsoft/vscode)

## Setup

1. Clean VS Code profile with only ShellCheck (+ Copilot Chat) enabled.
   Do **not** set `shellcheck.ignoreFileSchemes` anywhere.
2. Open the `scenario-A-stale-linting/` folder (or the repo root) in VS Code.
3. Confirm ShellCheck is active: open `lintme.sh` — the Problems panel
   should show **6 violations**: SC2086, SC2034, SC2046, SC2005, SC2155,
   SC2181. (SC2005 accompanies SC2046 — `echo $(date)` — and is harmless
   for the repro; the agent may fix it along with SC2046.)

## Steps

1. Open a new Copilot Chat session (edit mode or agent mode).
2. Prompt Copilot with **exactly**:

   > Fix only the SC2086 and SC2034 issues in lintme.sh. Do not fix any
   > other issues.

3. Review the proposed edits and choose **Keep** for all of them.
4. Verify on disk: `shellcheck lintme.sh` (or reopen the file) — only
   SC2046, SC2155, SC2181 remain. The SC2086/SC2034 fixes are on disk.
5. Commit the change to git.
6. **Close VS Code entirely** (or Reload Window).
7. Reopen VS Code, then reopen the **same chat session** from the Chat
   view's history.
8. Observe the Problems panel.

## Expected (buggy) result

The Problems panel shows violations for the **pre-edit snapshot content**,
including SC2086 and SC2034 — the two issues that were fixed and committed
in step 5. Clicking either entry opens a tab whose content is the old
(pre-fix) version of `lintme.sh`.

Distinguishing stale entries from real ones: the real (disk) violations are
SC2046/SC2005/SC2155/SC2181; **SC2086 and SC2034 appearing in the Problems
panel is the proof of the defect**, since those are fixed on disk.

## Identifying the snapshot tab

The stale tab is indistinguishable from a live tab by filename/icon/tooltip
(the tooltip shows the plain filesystem path). Observable tells:

- **Timeline panel is empty** for that tab (a live file has git history)
- Content does not match `git show HEAD:scenario-A-stale-linting/lintme.sh`
- Hovering the tab and reading the full tooltip URI reveals a
  `chat-editing-snapshot-text-model:` scheme (only visible in the tooltip)

## Confirmed workaround (for reference, do NOT apply during repro)

```json
"shellcheck.ignoreFileSchemes": [
  "git", "gitfs", "output",
  "chat-editing-text-model",
  "chat-editing-snapshot-text-model"
]
```

Setting this stops the stale repopulation entirely — which also confirms
the diagnostics are attached to the virtual documents, not the disk files.

## Screenshots to capture

1. Problems panel after step 3 (baseline: 5 violations)
2. Problems panel after step 8 (stale entries incl. SC2086/SC2034)
3. The snapshot tab opened from a Problems click, next to a terminal
   showing `git show HEAD:...lintme.sh` proving the fix is committed
4. Tab tooltip showing the filesystem path (demonstrating
   indistinguishability)

## Verified on

- VS Code: _(fill in from Help → About)_
- Copilot Chat: _(fill in from Extensions panel)_
- OS: Windows 11 + WSL2 Ubuntu remote
