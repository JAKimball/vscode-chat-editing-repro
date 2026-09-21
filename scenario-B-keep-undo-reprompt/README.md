# Scenario B — Keep/undo review re-prompted for already-kept edits on resume

**Defect:** After resuming a past Copilot Chat editing session, VS Code
presents a keep/undo review round for **all** edits since an early snapshot
baseline — including edits that were already kept in prior sessions and
committed to git.

**Upstream issue draft:** `issue-draft-B-keep-undo-reprompt.md` (microsoft/vscode)

## Setup

1. Clean VS Code profile (extensions don't matter for this scenario, but
   keep the same clean profile for consistency).
2. Open the `scenario-B-keep-undo-reprompt/` folder (or the repo root).
3. `app.sh` contains three independent functions: `greet`, `sum`, and
   `banner`.

## Steps

1. Open a new Copilot Chat session (edit mode or agent mode).
2. Make **three separate edit rounds**, keeping each one:

   Round 1 — prompt:

   > Add a function `farewell` that prints "Goodbye!" to app.sh.

   → review → **Keep** all edits.

   Round 2 — prompt:

   > Add a function `repeat` that takes a word and a count and prints the
   > word `count` times, to app.sh.

   → review → **Keep** all edits.

   Round 3 — prompt:

   > Modify the `banner` function in app.sh to print the message in
   > uppercase.

   → review → **Keep** all edits.

3. Commit to git after each keep (or at minimum after round 3 — committing
   per round makes the "already committed" claim unambiguous):

   ```sh
   git add -A && git commit -m "round N"
   ```

4. Verify on disk: `grep -c '^[a-z_]*()' app.sh` shows the new functions
   exist; `git log --oneline` shows the commits.
5. **Close VS Code entirely** (or Reload Window).
6. Reopen VS Code, then reopen the **same chat session** from the Chat
   view's history.
7. Observe the edit-review UI.

## Expected (buggy) result

VS Code presents a "review all changes" keep/undo round covering **all
three rounds of edits** — including the ones already kept and committed.
The review baseline is recomputed against an early snapshot rather than
reconciled against the on-disk files.

**Severity note:** choosing **Undo** on any of these re-presented edits
would revert content that is already committed — a data-loss risk, not just
an annoyance. Choosing Keep is a no-op write (disk already has the content),
but the UI gives no indication of that.

## Screenshots to capture

1. The review round after step 7, showing edits from all three rounds
2. Terminal showing `git log --oneline` proving the edits were committed
   before the reload
3. (Optional) The same session pre-reload, showing all rounds were kept

## Verified on

- VS Code: _(fill in from Help → About)_
- Copilot Chat: _(fill in from Extensions panel)_
- OS: Windows 11 + WSL2 Ubuntu remote
