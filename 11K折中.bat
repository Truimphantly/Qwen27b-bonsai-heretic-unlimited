@echo off
title [MID-DOC MODE] context 11264 - Bonsai 27B @ 127.0.0.1:8080
echo [MID-DOC MODE] context=11264, port=8080, closing previous instance...
taskkill /F /IM llama-server.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul
REM ============================================================
REM  Middle-ground mode: 11264-token context (between the 4K and
REM  14K bats). Measured 2026-10-13, 129-run sample: decode
REM  ~11.5 tok/s live -- same speed as the 14K compromise, with a
REM  smaller VRAM commit (~6.6GB total incl. desktop), so it is
REM  the safest long mode when desktop apps are heavy.
REM  Speed here is decided by the 4-layers-on-CPU trade and -fa
REM  off, NOT by the context length. Inherited hygiene rules:
REM  -t 8, no verbose logging, reasoning budget 8192, --no-warmup,
REM  and auto-close of the previous instance.
REM ============================================================
cd /d %~dp0
runtime\llama-server.exe -m models\Ternary-Bonsai-2-27B-Uncensored-Heretic-PTQ1_0.gguf -ngl 61 -fa off -c 11264 --parallel 1 -t 8 --reasoning on --reasoning-effort medium --reasoning-budget 8192 --no-warmup --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.05 -n 16384 --host 127.0.0.1 --port 8080
pause
