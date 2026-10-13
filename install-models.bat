@echo off
title Install model weights - Heretic PTQ1_0 + mmproj (~6.6GB from hf-mirror)
echo ============================================================
echo  STEP 2 of 2 - downloading model weights (~6.6GB, resume-safe)
echo  Source: huggingface.co via hf-mirror.com (China friendly)
echo ============================================================
cd /d %~dp0
if not exist models mkdir models
echo [1/2] Ternary-Bonsai-2-27B-Uncensored-Heretic PTQ1_0 (5.95GB) ...
curl -L -C - --retry 8 --retry-delay 3 -o "models\Ternary-Bonsai-2-27B-Uncensored-Heretic-PTQ1_0.gguf" "https://hf-mirror.com/OS-Software/Ternary-Bonsai-2-27B-Uncensored-Heretic-GGUF/resolve/main/Ternary-Bonsai-2-27B-Uncensored-Heretic-PTQ1_0.gguf"
if errorlevel 1 goto netfail
echo [2/2] vision projector mmproj-Q8_0 (0.63GB) ...
curl -L -C - --retry 8 --retry-delay 3 -o "models\mmproj-Q8_0.gguf" "https://hf-mirror.com/OS-Software/Ternary-Bonsai-2-27B-Uncensored-Heretic-GGUF/resolve/main/mmproj-Q8_0.gguf"
if errorlevel 1 goto netfail
echo ------------------------------------------------------------
echo done. Now double-click any of the four bat files in this folder:
echo   the two "4K" ones (chat / images) or the 11K / 14K long-document ones.
echo Browser opens http://127.0.0.1:8080
echo ------------------------------------------------------------
goto finish
:netfail
echo DOWNLOAD FAILED - just re-run this bat: downloads resume automatically.
echo (Direct source: huggingface.co/OS-Software/Ternary-Bonsai-2-27B-Uncensored-Heretic-GGUF)
:finish
pause
