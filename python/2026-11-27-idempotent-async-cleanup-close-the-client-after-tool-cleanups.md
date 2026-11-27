# Idempotent async cleanup: close the client after tool cleanups

**Date:** 2026-11-27 · **Topic:** python

## What I learned
A service that builds its own `AsyncOpenAI` client (over an httpx pool with `keepalive_expiry=None`) owns that client and has to close it in `cleanup()`, or every pipeline leaves its connections open. The order matters: call `super().cleanup()` first, because that is where registered tool cleanups run, and they may still need the client. Close the client last. A second `cleanup()` is safe, because closing an already-closed `AsyncOpenAI` client does nothing.

To check that the order test really tests the order, swap the two lines and run it again. It should fail. In pipecat#6947 it did, and the other four tests still passed. The ownership question is the other thing to check: only close a client the service created itself, not one a caller passed in through `http_client=`.

## Snippet
```python
async def cleanup(self):
    await super().cleanup()     # tool cleanups run here, client still open
    await self._client.close()  # no-op if already closed, so cleanup() is idempotent
```

## Source
- Issue: https://github.com/pipecat-ai/pipecat/issues/6946
- PR I reviewed: https://github.com/pipecat-ai/pipecat/pull/6947
- Same fix for chat completions: https://github.com/pipecat-ai/pipecat/pull/6284
