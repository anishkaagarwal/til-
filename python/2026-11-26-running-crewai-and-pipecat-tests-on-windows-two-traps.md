# Running crewAI and pipecat tests on Windows: two traps

**Date:** 2026-11-26 · **Topic:** python

## What I learned
1. **`--block-network` breaks asyncio on Windows.** crewAI's pytest config uses pytest-recording's `--block-network`. On Windows, asyncio's `ProactorEventLoop` creates its self-pipe with `socket.socketpair()`, which the guard blocks, so *every* test fails with `RuntimeError: Network is disabled`. Override the addopts for a local run.
2. **Smart App Control can block native wheels.** pyarrow's `_dataset` DLL was blocked by Windows Application Control ("DLL load failed ... blocked this file"). crewAI's `Flow()` auto-creates Memory, which imports lancedb, which imports pyarrow. A tiny pytest plugin that stubs the storage module in `sys.modules` got the Flow tests running without touching the repo.

Also: crewAI needs Python <3.14 (`py -3.11 -m venv`), and `pip install uv` inside the venv works when uv isn't installed system-wide. For regular contributions, WSL or a dev container avoids all of this.

## Snippet
```powershell
# crewAI: drop -n auto and --block-network, keep importlib mode
python -m pytest lib/crewai/tests/test_flow_conversation.py -p stub_lancedb `
  -o addopts="--import-mode=importlib --timeout=60"
# pipecat: its addopts include -n auto (xdist); clear them if xdist isn't installed
python -m pytest tests/test_aws_tts.py -o addopts=""
```

## Source
- crewAI `pyproject.toml` `[tool.pytest.ini_options]`
- https://github.com/kiwicom/pytest-recording (network blocking)
