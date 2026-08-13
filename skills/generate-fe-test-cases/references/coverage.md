# Coverage floor and regression scope

Read before you generate cases. Apply the floor per ticket, before the
consolidation pass — consolidation removes cases, so the floor must stand first.

## Coverage floor

Each AC gives at least one positive case. Then check these classes and write a case
wherever the change makes one reachable. Where a class is not reachable, say so in
one line — do not silently omit it. A PRD that omits a class is not evidence the
class does not exist.

| Class | Ask |
|---|---|
| Negative / validation | Wrong, missing, or out-of-range input on any field the change touches. |
| Boundary | Min, max, and one-past-max for any limit, count, or date range. |
| State transition | Every status the entity can hold when the action is attempted (e.g. survey `PENDING` / `IN PROGRESS` / `STOPPED` / `COMPLETED`). |
| Permission | Every subject in the product's subject list that can reach the surface. |
| Empty / loading / error | No data, slow response, and failed request on any view the change adds or alters. |
| Persistence | Reload or re-enter after save — the change survives. |
| Accessibility | Keyboard-only path, visible focus, and a screen-reader label on any control the change adds or alters. |
| Authorization | A subject without rights is blocked from the action or route — assert the UI blocks it, not just the server. |

## Testing Phase — Feature vs Regression

Tag every case by scope and granularity, not by old-vs-new.

**Feature** — one behavior, scoped strictly to the PRD change.

- Tests the smallest verifiable detail of a single AC (e.g. "the ScreenOut label is
  red"). One behavior per case — this is where the Gherkin one-behavior rule applies.
- Scope = only what this PRD changed. Nothing outside it.
- Every AC and every coverage-floor class above produces Feature cases.

**Regression** — one end-to-end flow, bundling many behaviors.

- Walks a whole journey start to finish (e.g. run a survey: build → answer →
  screen-out → submit → notification), asserting many behaviors in one case —
  including ones already covered atomically by Feature cases.
- Scope may reach outside this PRD into related behavior in neighbour PRDs (the
  Step 2 scan) when the flow passes through them.
- The overlap with Feature cases is deliberate. A regression run cannot execute
  every Feature case, so a few broad e2e Regression cases stand in for that
  coverage. Redundancy here is the point, not a defect.
- A Regression case asserts several behaviors in one scenario — the "one behavior
  per scenario" rule is relaxed for it; the journey is the unit.
- Write at least one Regression case per end-to-end flow (from the Step 3
  decomposition) that the change participates in. None for a flow it cannot reach.

**Exactly one phase per case — never both.** A case that could serve both roles is
split into a Feature case (isolates the one behavior) and a Regression case (walks
the flow). Never tag one case as both. Tag by what the case actually does: a single
atomic assertion → `Feature`; an end-to-end walk → `Regression`.
