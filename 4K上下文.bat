@echo off
title [TEXT MODE] context 4096 - Bonsai 27B @ 127.0.0.1:8080
echo [TEXT MODE] context=4096, port=8080, closing previous instance...
taskkill /F /IM llama-server.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul
REM ============================================================
REM  Ternary-Bonsai-2-27B-Uncensored-Heretic PTQ1_0 (5.95 GB)
REM  After this window shows "listening", open http://127.0.0.1:8080
REM
REM  Measured on RTX 4070 Laptop 8G (desktop apps running):
REM    decode ~27 tok/s, prefill ~100 tok/s, about 7.2 GB VRAM.
REM
REM  Known pitfalls on this build (see README_Usage.txt for Chinese notes):
REM   1) Do NOT raise -c above 4096: this binary decodes at ~2 tok/s
REM      beyond it (upstream issue #252, fix pending a newer release).
REM   2) Do NOT add -ctk/-ctv quantized KV: hybrid attention drops
REM      below 1 tok/s with them.
REM   3) Keep -n 16384: the model thinks long; a small cap yields
REM      empty answers.
REM ============================================================
cd /d %~dp0
runtime\llama-server.exe -m models\Ternary-Bonsai-2-27B-Uncensored-Heretic-PTQ1_0.gguf -ngl 99 -fa on -c 4096 --parallel 1 --jinja --reasoning on --reasoning-effort medium --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.05 -n 16384 --reasoning-budget 8192 --no-warmup --host 127.0.0.1 --port 8080
pause
