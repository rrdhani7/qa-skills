---
name: generate-fe-test-cases
description: >-
  Generate frontend QA test cases grounded strictly in source material. Use when
  the user wants to create, draft, or derive frontend test cases from a PRD, Jira
  ticket, or Figma design (e.g. "buat test case dari PROJ-123"). Starts from the
  QA's Obsidian PRD note, scans related PRDs in the vault (same product hub and
  other products) and the existing titis-tcms test-case corpus, reads PRD + Jira
  + design, decomposes the change into flows and locks scope before writing,
  applies a coverage floor, requires a Ground Truth per case,
  and outputs one .xlsx per sprint into Drafts/test-cases/ (file name = sprint
  name, one tab per Jira ticket)
  based on test_case_template.xlsx.
---

# Frontend Test-Case Generator

You are a Senior QA Engineer. Generate frontend test cases from product
requirements. Every case must trace to explicit source material — never infer or
assume, and never write a case without a **Ground Truth**. Output is a draft for
peer review before QMetry import.

## Step 1 — Gather inputs (all required unless the user skips one)

The QA writes the PRD summary note in this Obsidian vault **first**; that note is
your entry point.

1. **Obsidian PRD note** — the QA's summary in `PRDs/`. Read it to get the
   feature, product, and `source_url`, then follow `source_url` to read the full
   Confluence PRD via Atlassian MCP — that page is the source of truth for
   verbatim ACs. The note orients you; do not derive ACs from it. Cite PRD
   sections (`PRD §4.3`).
2. **Product** — take it from the note's `product` wikilink (e.g. AngketJS); it
   sets the allowed subjects (`references/columns.md`). Ask if unclear.
3. **Jira ticket** — read via Atlassian MCP. Extract scope, ACs (each AC =
   candidate case), out-of-scope. Ticket ID → `Story Linkages` value + tab name.
4. **Figma screenshots** — ask the user to paste them. Visual ground truth for
   element states, feedback, error/empty states, layout. Cite as `Design — <desc>`.

## Step 2 — Scan related PRDs (MANDATORY GATE — you do this, not the user)

A pre-existing "Related PRDs" section inside the source note does not count as the
scan — open the actual neighbour notes yourself and verify.

1. Open the product hub `_MOC/Products/<Product>.md` to list the same-product PRDs.
2. **Actually open / grep each same-product PRD note** for the feature's keywords
   (e.g. logic, skip, show/hide, piping, code, move, reorder, page, export,
   matrix, media). Base-builder PRDs (e.g. Internal Survey Builder, Basic Survey
   Builder) are prime sources of pre-existing behavior the change may regress.
3. Then broaden to cross-product topical neighbours in `PRDs/`.
4. **Output a Related-PRD scan log before generating** — one line per neighbour
   checked: `PRD name · relevant behavior found? (Y/N + what) · source_url`.
   A neighbour whose behavior the change touches becomes a **grounded regression
   case**, cited by that neighbour's `source_url` (not "interpretation"/"to confirm").

Relations are your interpretation unless a neighbour PRD states them — mark them
as such; do not write `related`/`depends_on` back into vault notes.

### 2b — Scan the existing test-case corpus (same gate)

`test-cases/<Product>/` mirrors what titis-tcms already owns — the strongest
regression baseline available, and the only way to avoid re-writing a case that
already exists.

1. Resolve the folder from the product via the mapping table in `CLAUDE.md` §2 —
   folder names do not all match product names. Do not guess.
2. Open `test-cases/<Product>/TC-<Product>.md` for the area list, then open the
   area notes whose subject the change touches. Each is a table of
   `TC-<id> | Summary | Priority | Steps`.
3. Grep the product folder for the same feature keywords used above.
4. Add to the scan log — one line per area checked:
   `area · existing TC ids touching this behavior · duplicate or regression baseline?`
5. If the product has no folder (PopSurvey today), log
   `no TCMS baseline — PRD neighbours only`. Never log "no relevant cases found".

An existing TC the change may break becomes a `Regression` case, cited by its
`TC-<id>` in Ground Truth.

## Step 3 — Plan and lock scope (GATE — confirm before generating)

1. **Decompose into flows.** A feature is a set of end-to-end journeys, not a flat
   list of ACs (e.g. add question → configure → save; set logic → preview → export).
   List the flows the change touches. A multi-step conversation is one flow, not one
   case per screen.
2. **Map coverage per flow.** For each flow, list the cases its ACs and the coverage
   floor (`references/coverage.md`) require.
3. **Ask before assuming.** If any AC, rule, state, or subject right is still a
   guess, ask now — never generate on an assumption. One line per unknown:
   `what you need · why it blocks a case`.
4. **Lock.** Present in one message: the flow list, the planned case count per flow,
   and the output target (`Drafts/test-cases/{sprint}.xlsx`, tab = ticket ID). Wait
   for confirmation before writing any case.

## Step 4 — Generate

Before writing a single case, read `references/columns.md` (column contract,
Priority/Automation rubrics, Gherkin rules, subject table) and
`references/coverage.md` (coverage floor, regression scope).

- **Never author the .xlsx by hand.** Write the cases as JSON and run
  `scripts/build_sprint_xlsx.py cases.json` (`--dry-run` to preview). It reads the
  columns from `Templates/test_case_template.xlsx`, rewrites only the ticket's tab,
  and refuses a case with no Ground Truth, an unknown key, or a value in `Status` /
  `Bug Links`. JSON shape is in the script's docstring.
- File and tab rules:

  | Rule | Detail |
  |---|---|
  | Location | `Drafts/test-cases/` — never `test-cases/` (read-only titis-tcms sync target, `CLAUDE.md` §2). |
  | File name | The sprint name (`{SPRINT_NAME}.xlsx`, e.g. `ES-176.xlsx`). Ask if not obvious from the tickets. |
  | Tabs | One Jira ticket per tab; one sprint file can hold tickets from several PRDs. |
  | Existing file | Add or replace the ticket's tab — never create a second file for the same sprint. |
  | Legacy files | Sprint files named after a PRD instead of a sprint are legacy — leave them as they are. |

## Step 5 — Consolidate (redundancy pass before finalizing)

- **Merge** cases sharing the same condition — but only within the same Testing
  Phase. A Feature case and a Regression case that overlap are both kept; that
  redundancy is intended (`coverage.md` Testing Phase).
- **Save subsumes view** — keep the save/submit case, drop view-only, fold the view
  assertion in as an intermediate step.
- **Stronger subsumes weaker** — for same subject + logic type, keep the superset
  workflow.
- **One case per (improvement × meaningful variant)** — cover each behavior once;
  merge variants that behave identically.
- A screenshot element is not a test trigger — only test the ticket's change or its
  direct regression risk.

## Step 6 — Self-check (do not write the file until every line passes)

Print this list with a Y/N per line:

1. Every AC in the ticket maps to ≥1 case — list `AC → case Summary`.
2. Every coverage-floor class is covered, or explicitly marked not reachable.
3. Every case belongs to a flow from the Step 3 plan; no case falls outside the locked scope.
4. Every Feature case tests exactly one behavior; every end-to-end flow the change reaches has ≥1 Regression case (`coverage.md` Testing Phase).
5. No two Summaries describe the same condition after consolidation (Feature/Regression overlap is expected and allowed).
6. No Summary duplicates an existing TC found in step 2b, or the difference is stated.
7. Every Subject appears in the product's subject list.

Any `N` blocks the write. Fix it or ask.

## Flags

- PRD ↔ Jira conflict, or design ↔ PRD conflict → flag and ask (a design/PRD
  mismatch may itself be a bug).
- No credentials, phone numbers, or owner/assignee names — refer to roles.
