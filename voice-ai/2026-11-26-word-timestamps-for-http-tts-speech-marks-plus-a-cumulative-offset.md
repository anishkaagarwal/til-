# Word timestamps for HTTP TTS: speech marks plus a cumulative offset

**Date:** 2026-11-26 · **Topic:** voice-ai

## What I learned
Word-level timestamps let a voice bot know exactly which words were spoken before an interruption, so the LLM context only holds what the user actually heard. Websocket TTS providers stream timings with the audio. HTTP providers like Amazon Polly can't: `OutputFormat` is single-valued, so you need a **second** `synthesize_speech` call with `OutputFormat="json"` and `SpeechMarkTypes=["word"]`. It returns newline-delimited JSON with each word's start time in ms. Run it **concurrently** with the audio call so it adds no latency, and fall back to timing the whole sentence if it fails.

Each request only knows times within its own sentence, so the service keeps a `_cumulative_time`: add each sentence's audio duration (`len(pcm) / (sample_rate * 2)` for 16-bit mono) and reset it on interruption or end of turn. Pipecat's base class anchors the baseline at the first audio chunk of the turn. ElevenLabs, Inworld, Speechify and Rime all use this same pattern.

Gotchas: the mark values are substrings of the SSML, so `unescape()` them. Polly's generative engine has no speech marks. The marks call doubles the Polly cost, so make it opt-in.

## Snippet
```python
word_times = [(w, self._cumulative_time + start) for w, start in marks] \
             or [(text, self._cumulative_time)]          # fallback: whole sentence
await self.add_word_timestamps(word_times, context_id)
self._cumulative_time += len(pcm) / (sample_rate * 2)  # reset on InterruptionFrame / TTSStoppedFrame
```

## Source
- PR I reviewed: https://github.com/pipecat-ai/pipecat/pull/6375 (issue #1015)
- Polly speech marks: https://docs.aws.amazon.com/polly/latest/dg/speechmarks.html
