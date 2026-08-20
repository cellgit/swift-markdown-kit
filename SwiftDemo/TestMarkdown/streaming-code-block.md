# Streaming Code Block

The opening fence may arrive before the closing fence.

```swift
import SwiftMarkdownKit

let renderer = MarkdownRenderViewController()
renderer.startStreaming()
renderer.appendChunk("# Hello")
renderer.finishStreaming()
```

The content after the code block should recover normal paragraph layout.
