# Today I Learned 📒

Short daily notes on what I learn while building agentic AI, RAG and voice AI systems, plus a log of my open-source work.

Each note is a few lines: what I learned, a snippet if useful, and a link. No essays.

## Layout
| Folder | What goes in it |
|---|---|
| [`agents/`](agents) | LangGraph, CrewAI, Google ADK, multi-agent patterns |
| [`rag/`](rag) | Retrieval, embeddings, vector DBs, chunking |
| [`voice-ai/`](voice-ai) | STT/TTS, latency, prompts and state for voice agents |
| [`llmops/`](llmops) | Evals, tracing, cost, p95 latency |
| [`python/`](python) | Python, FastAPI, async |
| [`cloud/`](cloud) | GCP, Docker, Kubernetes, CI/CD |
| [`dsa/`](dsa) | Patterns behind problems (solutions live in [daily-dsa](https://github.com/anishkaagarwal/daily-dsa)) |
| [`oss-log/`](oss-log) | One file per month: issues, PRs, reviews and docs fixes in open-source repos |
| [`daily/`](daily) | One checklist per day from the morning Slack brief: own-repo task, open-source picks, PR to review, TIL |

## Adding a note
```powershell
./new.ps1 rag "hybrid search beats pure vector search on short queries"
```
This creates `rag/2026-11-24-hybrid-search-beats-pure-vector-search-on-short-queries.md` from [`TEMPLATE.md`](TEMPLATE.md) and adds it to the list below.

## Daily routine
1. At 9 AM a GitHub brief arrives on Slack.
2. Run `./today.ps1` to create `daily/<date>.md` and paste the brief's items into it.
3. Work through them. Tick each one and paste the link to your commit, PR, issue comment or review.
4. Write the TIL note with `./new.ps1`, then commit and push.

## Daily log
<!-- daily:start -->
- [2026-11-24](daily/2026-11-24.md)
<!-- daily:end -->

## Notes
<!-- notes:start -->
<!-- notes:end -->
