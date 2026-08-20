# Math Streaming

This fixture should be streamed token by token.

The renderer should not collapse while inline math is incomplete: $\\sum_{i=1}^{n} i =
\\frac{n(n+1)}{2}$.

Block math may arrive over several chunks:

$$
\\lim_{n \\to \\infty} \\left(1 + \\frac{1}{n}\\right)^n = e
$$
