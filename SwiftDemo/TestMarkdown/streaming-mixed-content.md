# Streaming Mixed Content

> A blockquote should remain readable while new tokens are appended.

- First list item
- Second list item with [a link](https://example.com)
- Third list item with `inline code`

Inline math should recover after closure: $a^2 + b^2 = c^2$.

```js
const chunks = ["# Hello", "\\nworld"];
for (const chunk of chunks) {
  appendChunk(chunk);
}
```

| Feature | Expected |
| --- | --- |
| Markdown | stable |
| Math | fallback then render |
| Code | copyable |
