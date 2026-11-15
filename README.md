# jarvis-sl

A voice helper in Slovenian, and an open table of Slovenian dialect words.

- `jarvis.sh`: you speak, whisper.cpp writes it down, Claude answers, the macOS voice Tina reads it out. Free tools only.
- `narecja.md`: one table of dialect words. Anyone can add a row by pull request.
- `update.sh`: every 4 hours it takes new dialect words from the private inbox and opens a draft PR. Your full sentences never leave your Mac.

## Run

Needs `whisper-cli` (Homebrew `whisper-cpp`), `ffmpeg`, Claude Code, and the model `~/models/ggml-base.bin` from huggingface.co/ggerganov/whisper.cpp.

```bash
./jarvis.sh            # MIC=2 SECS=8 by default
```
