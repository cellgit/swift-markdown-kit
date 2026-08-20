# Math Error Fallback

Invalid math should not blank the whole response.

Inline invalid math: $\\notacommand{abc}$ should fall back visibly.

Block invalid math:

$$
\\begin{aligned}
missing end
$$
