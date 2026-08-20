# Streaming Table

Tables are fragile while incomplete. The renderer should avoid large layout corruption before all rows arrive.

| Token | Meaning | Status |
| --- | --- | --- |
| `ready` | Web renderer loaded | stable |
| `rendered` | Initial render finished | stable |
| `heightChanged` | Content height changed | debounced |

After the table, regular Markdown should render normally.
