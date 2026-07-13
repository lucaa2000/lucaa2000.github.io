# Repository Agent Guidelines

These instructions apply to every change in this repository.

## Pull-request-only workflow

- Never commit or push directly to `main`.
- Create a dedicated branch for every change.
- Commit and push only that branch.
- Make the change available as a pull request for the user to review.
- Never merge a pull request or otherwise update `main` without the user's explicit approval.

## Karpathy Rules

These rules are derived from Andrej Karpathy's observations about common coding-agent failure modes. They favor caution over speed; use judgment for trivial tasks.

### 1. Think before coding

- Do not make silent assumptions or hide uncertainty.
- State material assumptions and surface relevant tradeoffs before implementing.
- If multiple interpretations would lead to meaningfully different results, present them instead of choosing silently.
- If requirements are unclear and a wrong assumption would be costly, stop and ask.
- Point out a simpler approach when one exists, and push back when warranted.

### 2. Simplicity first

- Write the minimum code needed to solve the requested problem.
- Do not add speculative features, abstractions, flexibility, or configurability.
- Avoid abstractions for one-off code and error handling for impossible scenarios.
- Prefer clear, direct code over clever code.
- If the implementation is substantially larger than the problem warrants, simplify it.

### 3. Make surgical changes

- Touch only files and lines that directly support the request.
- Do not refactor, reformat, or “improve” unrelated code.
- Match the repository's existing style and conventions.
- Leave unrelated dead code in place and mention it separately if relevant.
- Remove imports, variables, functions, and files made obsolete by your own changes.
- Before finishing, confirm that every changed line traces back to the request.

### 4. Execute against verifiable goals

- Define concrete success criteria before implementing non-trivial work.
- For multi-step work, state a brief plan and how each step will be verified.
- Prefer tests that reproduce a bug or demonstrate the requested behavior.
- Run the relevant tests, build, linting, and validation before claiming completion.
- Continue iterating until the success criteria pass; report any check that could not be run.
