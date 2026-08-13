# Case shape

Read before you generate cases. Column names are the template's; the script takes
them from `Templates/test_case_template.xlsx`, so never rename or reorder them.

## Subjects

Every Summary starts with a real actor.

| Product | Subjects |
|---|---|
| AngketJS (Internal Survey Builder) | `Scripter` · `Respondent` |
| Backoffice (Admin Panel) | `Admin` |
| PopSurvey (researcher app) | `Researcher` · `System` · `Technical Admin` |

If the product is not listed or not specified, stop and ask.

## Columns

| Column | Guidance |
|---|---|
| **Summary** | `Subject → Verb → Object → Adverb`, e.g. `Scripter can add a question successfully`. Name the exact sub-region acted on (`…in the IF condition`, not `…in the logic rule`). |
| **Priority** | `Blocker` · `High` · `Medium` · `Low` — rubric below. |
| **Step Summary** | Gherkin (`Given`/`When`/`And`/`Then`). |
| **Test Data** | Input values per step. |
| **Expected Result** | UI assertions: element state · URL/route · visual feedback. |
| **Story Linkages** | Jira ticket ID. |
| **Testing Phase** | `Feature` · `Regression` · `Feature, Regression` — pick with the Testing Phase rules in `coverage.md`. |
| **Automation Status** | `PLAN` · `CAN'T AUTOMATE` — rubric below. |
| **Ground Truth** | Verbatim quote / design observation + source ref (`PRD §4.3`, `Jira PROJ-123 AC#2`, `Design — …`, `TC-720`). |
| **Status** | Leave empty — titis-tcms owns it after import. |
| **Bug Links** | Leave empty — filled during execution. |

## Priority

| Priority | Use when |
|---|---|
| `Blocker` | The ticket's main path cannot complete, or data is lost or corrupted. |
| `High` | A named AC fails, or a listed role is wrongly allowed or denied. |
| `Medium` | Secondary path, recoverable error handling, or a non-blocking visual defect. |
| `Low` | Cosmetic, copy, or reachable only through an unlikely sequence. |

## Automation Status

`PLAN` when the case runs against a stable selector or route, needs no visual
comparison, and no manual external system. Otherwise `CAN'T AUTOMATE`, followed by
the reason in one clause.

## Gherkin

- **Given** = a state, not an action. **When** = one action per step. **And**
  inherits the prior keyword. **Then** stays in Step Summary.
- 3rd person (`the Scripter`, never "I"), present tense, complete sentences.

```gherkin
Given the Survey Editor is at Time Picker settings with Date Limits ON
When the Scripter sets Start Date Limit to {{START_DATE}}
And the Scripter sets End Date Limit to {{END_DATE}}
Then no validation error is displayed and the date limits are saved
```
