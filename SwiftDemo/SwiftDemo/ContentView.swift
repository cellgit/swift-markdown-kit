//
//  ContentView.swift
//  SwiftDemo
//
//  Created by liuhongli on 2026/5/21.
//

import SwiftUI
import UIKit
import SwiftMarkdownKit

struct ContentView: View {
    @State private var status = "loading"

    var body: some View {
        NavigationStack {
            MarkdownRenderView(
                markdown: sampleMarkdown,
                options: MarkdownRenderOptions(
                    theme: .system,
                    contentPadding: UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18),
                    bottomGap: 24
                )
            ) { event in
                switch event {
                case .ready:
                    status = "renderer ready"
                case .rendered(let height):
                    status = "rendered \(Int(height))pt"
                case .heightChanged(let height):
                    status = "height \(Int(height))pt"
                case .error(let error):
                    status = String(describing: error)
                case .action(let action):
                    status = "action: \(action)"
                @unknown default:
                    status = "unknown renderer event"
                }
            }
            .navigationTitle("Swift Markdown Kit")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text(status)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }
}

private let sampleMarkdown = ##"""
# Swift Markdown Kit · v0.0.3

## Math smoke test (top-of-page)

Inline math: $E = mc^2$ · Pythagoras: $a^2 + b^2 = c^2$ · Ratio: $\tfrac{1}{2}$.

$$
\int_0^1 x^2\, dx = \frac{1}{3}
$$

Currency stays literal: $10 and $20 today.

> **Boundary rules.** The renderer is deliberate about what becomes math:
>
> - Currency stays text: $10 and $20 never become a formula.
> - Inline `$...$` never spans a code span, so the `$x$` here is just code.
> - `\(C\)` with no spaces *is* valid inline math and renders as \(C\).
> - `\( C \)` with spaces inside stays literal: \( C \).

## Non-standard markdown

Model output is only approximately standard, and none of it turns red. An
expression KaTeX cannot parse falls back to the characters that were written,
in the surrounding text colour:

- Unclosed brace: $x^{2$ — shown exactly as typed.
- Unknown macro: $\foobarbaz{x}$ — not painted red.
- Unbalanced display delimiters: \[ \frac{a}{b \]
- A bracketed citation stays in its sentence: see \[1\] for details.
- Unclosed emphasis stays literal: **bold that never closes
- A valid formula next to all of that still renders: $\int_0^1 x^2\,dx = \tfrac13$

---

This demo renders one comprehensive Markdown document through
`SwiftMarkdownKit.xcframework`. It exercises every renderer feature that
ships in v0.0.3, including the streaming-friendly math and code paths.

## Headings

### Level 3

#### Level 4

##### Level 5

###### Level 6

## Inline formatting

Regular paragraph with **bold**, *italic*, ***bold italic***,
~~strikethrough~~, `inline code`, and [a link](https://example.com).
A second sentence shows :rocket: emoji shortcodes and a soft
line break (two trailing spaces).

## Lists

### Unordered with nesting

- Top-level item
  - Second-level item
    - Third-level item with `inline code`
  - Another second-level
- Top-level with a [link](https://swift.org)

### Ordered

1. First step
2. Second step with **emphasis**
3. Third step containing inline math: $a^2 + b^2 = c^2$
   1. nested step
   2. nested step

### Task list

- [x] Re-render core renderer
- [x] Wire SDK options
- [ ] Add SwiftChatDemo (roadmap)
- [ ] Tree-shake KaTeX (roadmap)

## Quotes

> "Premature optimization is the root of all evil."
> — Donald Knuth

> Nested quotes work too.
>> Second level.
>>> Third level.

## Tables

### Compact table

| Feature      | Status        | Notes                                   |
| ------------ | ------------- | --------------------------------------- |
| GFM tables   | Supported     | Auto-wrapped in `.table-container`       |
| Code blocks  | Supported     | Copy button on header                    |
| Math         | Supported     | KaTeX inline + block                     |
| Streaming    | Incremental   | rAF-coalesced, O(n) total cost          |

### Wide table (should horizontally scroll, not overflow)

| ID  | Customer            | License Type | Bundle ID                              | Issued At                   | Updates Until / Valid Until    | Status     |
| --- | ------------------- | ------------ | -------------------------------------- | --------------------------- | ------------------------------ | ---------- |
| 1   | swift-demo          | trial        | com.liuhongli.SwiftDemo                | 2026-05-27T13:50:07.468Z    | 2026-06-26T13:50:07.468Z       | active     |
| 2   | company-alpha       | production   | com.alpha.app, com.alpha.app.dev       | 2026-05-01T00:00:00Z        | 2027-05-01T00:00:00Z           | active     |
| 3   | company-beta        | production   | com.beta.app                           | 2025-12-01T00:00:00Z        | 2026-12-01T00:00:00Z           | renewing   |

## Code blocks

### Swift

```swift
import SwiftMarkdownKit

let renderer = MarkdownRenderViewController()
renderer.onEvent = { event in
    if case .error(let error) = event {
        print(error.code, error.message)
    }
}
renderer.render("# Hello")
```

### JavaScript

```javascript
import { renderMarkdown, setTheme } from '@cellgit/markdown-render';

setTheme('dark');
const html = renderMarkdown('Inline math: $E = mc^2$', {
  allowRawHTML: false,
  math: true
});
```

### JSON

```json
{
  "format": "swift-markdown-kit-license-v2",
  "payload": "<base64url>",
  "signature": "<base64url ed25519>"
}
```

### Plain text (no language tag)

```
$ ./issue_trial_license.sh com.company.app
Created trial license at ./licenses/...
  validUntil:   2026-06-26T13:50:07.468Z
  licenseType:  trial
```

## Math

### Inline math

Einstein gave us $E = mc^2$ in 1905, and Pythagoras predates everyone with
$a^2 + b^2 = c^2$. Even ratios like $\tfrac{1}{2}$ render inline.

Adjacent dollars (`$10` and `$20`) and citation markers (`\(C\)` with a
space) MUST stay literal — see the rendered text below for proof:

- Currency: $10 and $20 today, totaling $30 ($30.00 to be exact).
- Citation: \( C \) is a reference, not an equation.

### Block math via `$$ … $$`

$$
\int_0^1 x^2\, dx = \frac{1}{3}
$$

$$
e^{i\pi} + 1 = 0
$$

### Block math via `\[ … \]`

\[
\sum_{i=1}^{n} i = \frac{n(n+1)}{2}
\]

### Multi-line system

$$
\begin{aligned}
\nabla \cdot \mathbf{E} &= \frac{\rho}{\varepsilon_0} \\
\nabla \cdot \mathbf{B} &= 0 \\
\nabla \times \mathbf{E} &= -\frac{\partial \mathbf{B}}{\partial t} \\
\nabla \times \mathbf{B} &= \mu_0 \mathbf{J} + \mu_0 \varepsilon_0 \frac{\partial \mathbf{E}}{\partial t}
\end{aligned}
$$

## Horizontal rule

---

## Images

![A pixel-art kitten placeholder](https://placehold.co/600x200/png?text=swift-markdown-kit)

## Footnote-style links

The SDK guide is [in the repo][guide]. The change-log lives at the same
[location][guide] so a real link only fires the bridge once when tapped.

[guide]: https://example.com/integration-guide

## Closing

That's everything the v0.0.3 renderer supports. If anything above looks
broken on your device, please attach the screenshot to a GitHub issue and
include the SDK release date (visible at the bottom of the screen).
"""##

#Preview {
    ContentView()
}
