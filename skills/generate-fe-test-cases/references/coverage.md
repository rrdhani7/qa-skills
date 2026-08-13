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

## Regression scope

Add a `Regression` case only when the change touches the **same code path or shared
control** — including the neighbours found in the Step 2 scans. Do not regress
unrelated behavior just because it shares a screen or a product hub. When unsure,
exclude and ask.
