@echo off
title Install runtime - Prism llama.cpp fork (CUDA 13.3 win-x64, ~570MB)
echo ============================================================
echo  STEP 1 of 2 - downloading runtime (~570MB, resume-safe)
echo  Source: github PrismML-Eng llama.cpp release prism-b10772-e8fd209
echo ============================================================
cd /d %~dp0
echo [1/2] CUDA runtime DLLs (~391MB) via gh-proxy.com ...
curl -L -C - --retry 5 --retry-delay 3 -o cudart.zip "https://gh-proxy.com/https://github.com/PrismML-Eng/llama.cpp/releases/download/prism-b10772-e8fd209/cudart-llama-bin-win-cuda-13.3-x64.zip"
if errorlevel 1 goto netfail
echo [2/2] llama-server fork binaries (~179MB) ...
curl -L -C - --retry 5 --retry-delay 3 -o llama-bin.zip "https://gh-proxy.com/https://github.com/PrismML-Eng/llama.cpp/releases/download/prism-b10772-e8fd209/llama-prism-b10772-e8fd209-bin-win-cuda-13.3-x64.zip"
if errorlevel 1 goto netfail
echo extracting ...
powershell -NoProfile -Command "Expand-Archive -Path 'cudart.zip' -DestinationPath 'runtime' -Force"
powershell -NoProfile -Command "Expand-Archive -Path 'llama-bin.zip' -DestinationPath 'runtime' -Force"
del cudart.zip llama-bin.zip
if exist runtime\llama-server.exe (echo OK: runtime\llama-server.exe installed.) else (echo ERROR: llama-server.exe missing after extract.) & goto finish
echo Done. Run install-models.bat next (model weights ~6.6GB).
goto finish
:netfail
echo DOWNLOAD FAILED. This bat uses gh-proxy.com (China friendly).
echo Direct fallback URLs (remove proxy prefix, needs global network):
echo   https://github.com/PrismML-Eng/llama.cpp/releases/download/prism-b10772-e8fd209/cudart-llama-bin-win-cuda-13.3-x64.zip
echo   https://github.com/PrismML-Eng/llama.cpp/releases/download/prism-b10772-e8fd209/llama-prism-b10772-e8fd209-bin-win-cuda-13.3-x64.zip
echo Re-run this bat later - downloads resume where they stopped.
:finish
pause
