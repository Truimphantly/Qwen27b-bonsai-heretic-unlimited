@echo off
title [LONG-DOC MODE] context 14336 - Bonsai 27B @ 127.0.0.1:8080
echo [LONG-DOC MODE] context=14336, port=8080, closing previous instance...
taskkill /F /IM llama-server.exe >nul 2>&1
ping -n 2 127.0.0.1 >nul
REM ============================================================
REM  LONG DOCUMENT / LONG CHAT MODE: 14336-token context.
REM  Everything else matches the text bat. Trades tiny speed for
REM  3.5x the context:
REM     -c 4096  -fa on  : ~27 tok/s   (default text bat)
REM     -c 14336 -fa off : ~22 tok/s solo / ~11 tok/s live (this bat)
REM     -c 16384 -fa off : ~8 tok/s (cliff; do not raise above)
REM     -c 20480 +       : ~1 tok/s (broken)
REM
REM  2026-10-13 night update (hang/cliff root cause found):
REM   - -ngl 61 (4 layers run on CPU): full-offload -ngl 99 at -c 14336
REM     commits ~7.2GB of VRAM and once desktop apps are loaded the
REM     commit exceeds 8GB physical -> WDDM pages KV/state over PCIe
REM     -> requests hang for minutes / decode crawls to 2 tok/s.
REM     Dropping 4 layers to CPU removes the over commitment: instant
REM     first token, stable ~11 tok/s (jitter with desktop load).
REM   - NO -lv 4: verbose per-token logging itself degrades the server
REM     badly on this build.
REM   - -t 8: matches P-core threads; default 16 adds hybrid jitters.
REM
REM  Measured (live, heavy desktop): first token ~1.3s, decode ~11 tok/s.
REM ============================================================
cd /d %~dp0
runtime\llama-server.exe -m models\Ternary-Bonsai-2-27B-Uncensored-Heretic-PTQ1_0.gguf -ngl 61 -fa off -c 14336 --parallel 1 -t 8 --reasoning on --reasoning-effort medium --reasoning-budget 8192 --no-warmup --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.05 -n 16384 --host 127.0.0.1 --port 8080
pause
