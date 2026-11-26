# Nested try/finally so restore runs even if cleanup raises

**Date:** 2026-11-26 · **Topic:** python

## What I learned
A `finally` block runs its statements in order, so if an earlier statement raises, the later ones never run. crewAI's `Flow.chat()` called `finalize_session_traces()` and *then* restored a flag it had temporarily flipped. When finalization raised, the restore was skipped and a reused Flow kept the temporary setting. The fix is to nest a second `try/finally` inside the first. The exception still propagates, finalization still runs once, and the restore always runs.

A good regression test injects a failing cleanup and asserts the state afterwards. Then check the test actually fails on the old code: one of the PR's two tests passed without the fix, so it wasn't testing the bug.

## Snippet
```python
# Before: restore is skipped if finalize raises
finally:
    self.finalize_session_traces()
    if changed:
        self.flag = previous

# After
finally:
    try:
        self.finalize_session_traces()
    finally:
        if changed:
            self.flag = previous
```

## Source
- Issue: https://github.com/crewAIInc/crewAI/issues/8069
- PR I reviewed: https://github.com/crewAIInc/crewAI/pull/9529
