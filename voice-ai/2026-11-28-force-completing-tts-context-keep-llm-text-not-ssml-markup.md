# Force-completing TTS context: keep LLM text, not SSML markup

**Date:** 2026-11-28 · **Topic:** voice-ai

## What I learned
When a TTS provider stops sending word timestamps partway through a sentence, the bot has to "force-complete" the rest so the LLM context still gets the whole turn. The easy option is to take what's left of the text you sent the TTS, but that text is SSML: `A<break time="300ms"/>B` ends up in the conversation history and in the client's transcript. The forced remainder should come from the **LLM's original text** for the context, and from the **user-facing text** (no tags, no rewrites) for what clients see.

There's a second trap. A word tracker usually has two cursors: what has been *spoken* and what has been *attributed*. Punctuation like the comma in "Yeah," gets attributed to "Yeah" before any event reports it. If you resume from the spoken cursor, the context gets `Yeah, , I can help`. Resume from the attributed cursor instead.

Even with both fixes, rewritten spans are still tricky. If "$5" was spoken as "five dollars" and only "five" was reported, the context correctly says `$5`, but the client has already shown "five", so the transcript reads `five $5`.

## Snippet
```text
# force-complete, per unfinished slot
text = tracker.get_remaining_user_facing_text()   # for clients: no SSML
raw  = tracker.get_unattributed_llm_text()        # for context: LLM text, after attributed punctuation
emit(TTSTextFrame(text, raw_text=raw))
```

## Source
- PR I reviewed: https://github.com/pipecat-ai/pipecat/pull/6855 (issue #6819; competing PR #7004)
