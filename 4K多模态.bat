@echo off
title [VISION MODE] context 4096 + images - Bonsai 27B @ 127.0.0.1:8080
echo [VISION MODE] context=4096 with mmproj, port=8080, closing previous instance...
taskkill /F /IM llama-server.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul
REM ============================================================
REM  Vision-enabled launch. Send images / screenshots in the chat.
REM
REM  Two fixes applied relative to the previous version
REM  (verify by sending this image: if asked about the color of a
REM  red square it must answer "red", in ~3 s):
REM   1) NO --jinja: with this build's chat template, jinja mode
REM      silently strips image content from the prompt (model says
REM      it received no image). Plain template mode passes images.
REM   2) --no-mmproj-offload: the mmproj projector stays in system
REM      RAM. Loading it into VRAM eats the last 0.7 GB and makes
REM      decode drop from ~27 tok/s to ~9 tok/s.
REM
REM  Measured with this config (RTX 4070 Laptop 8G, desktop busy):
REM    decode ~27 tok/s, prefill ~75-175 tok/s, image answer ~3 s.
REM ============================================================
cd /d %~dp0
runtime\llama-server.exe -m models\Ternary-Bonsai-2-27B-Uncensored-Heretic-PTQ1_0.gguf --mmproj models\mmproj-Q8_0.gguf --no-mmproj-offload -ngl 99 -fa on -c 4096 --parallel 1 --reasoning on --reasoning-effort medium --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.05 -n 16384 --reasoning-budget 8192 --no-warmup --host 127.0.0.1 --port 8080
pause
