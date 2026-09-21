# VS Code Chat Editing Repro

Minimal reproduction repository for two related defects in VS Code's
Copilot Chat editing subsystem:

- **Defect A** — Chat-editing virtual documents rehydrated on session resume
  are exposed to extensions and linted, producing stale Problems entries that
  open snapshot tabs indistinguishable from live files.
  (scenario: [`scenario-A-stale-linting/`](scenario-A-stale-linting/README.md))
- **Defect B** — Copilot Chat edit sessions re-prompt keep/undo review for
  edits already kept (and committed) in prior sessions after resume.
  (scenario: [`scenario-B-keep-undo-reprompt/`](scenario-B-keep-undo-reprompt/README.md))

## Prerequisites

- VS Code (stable; verified on the version listed in each scenario README)
- GitHub Copilot Chat extension (built-in on current builds), signed in
- **ShellCheck extension** (`timonwong.shellcheck`) — required for Defect A;
  the ShellCheck **binary** must be available (the extension bundles one on
  most platforms, or install `shellcheck` via your package manager)
- A **clean VS Code profile** is strongly recommended for determinism:
  - Profiles icon (top-center, next to the gear) → Create Profile… →
    "Create a new profile" (do **not** copy from an existing profile)
  - In the new profile, install only ShellCheck (+ Copilot Chat)
  - Over WSL remotes, also enable ShellCheck for the remote in the
    Extensions panel
- Do **not** set `shellcheck.ignoreFileSchemes` in user settings — the
  default blocklist is what allows the bug to reproduce. The repo's
  `.vscode/settings.json` deliberately does not set it either.

## Repository layout

```
.vscode/
  settings.json      # pins shellcheck behavior; no ignoreFileSchemes workaround
  extensions.json    # workspace-recommended extensions (ShellCheck)
scenario-A-stale-linting/
  README.md          # exact steps for Defect A
  lintme.sh          # file with deliberate, distinct ShellCheck violations
scenario-B-keep-undo-reprompt/
  README.md          # exact steps for Defect B
  app.sh             # file the agent will edit across multiple kept rounds
```

## Verified environment

- OS: Windows 11 host, WSL2 Ubuntu remote (`vscode-remote://wsl+Ubuntu/...`)
- VS Code / Copilot Chat versions: see scenario READMEs (fill in from
  Help → About before publishing)

## Notes for reviewers

- The chat session itself cannot be committed — it lives in local VS Code
  state. Each scenario README contains the exact procedure to create the
  session state that triggers the defect.
- The repro is the *procedure*, not the file contents alone.
- Both defects share the same underlying mechanism (chat-editing session
  state persisted and rehydrated on resume without reconciliation against
  disk) and are filed as separate issues with cross-references.
