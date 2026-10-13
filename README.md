# qwen27b-share — Qwen3.8-27B Windows 便携启动包

给别人用的迷你仓库:没有模型、没有大文件,只有 **4 个启动 bat + 2 个自动下载脚本 + 说明**。
朋友克隆(或网页下载 zip 解压)自己想要的文件夹之后,跑两个安装脚本,再双击 bat 即可使用。

## 硬件要求(朋友侧)

| 项 | 要求 |
|---|---|
| 系统 | Windows 10/11 x64 |
| 显卡 | NVIDIA,建议 ≥8GB 显存 |
| 内存 | 建议 16GB(8GB 会吃力) |
| 驱动 | 支持 CUDA 13 的 NVIDIA 驱动(2024 下半年以后的驱动即可;太旧先升) |
| 磁盘 | 本目录预留 ~8GB |
| 微软运行库 | 需要 VC++ 2015-2022 Redist(x64):https://aka.ms/vs/17/release/vc_redist.x64.exe |

## 三步开始

```bat
git clone https://github.com/Truimphantly/qwen27b-share.git
cd qwen27b-share
install-runtime.bat     REM 下载 PrismML llama.cpp fork 运行时 + CUDA DLL(~570MB)
install-models.bat      REM 下载模型权重 + 视觉投影(~6.6GB,走 hf-mirror,支持断点续传)
```

然后双击任意 bat 启动本地服务(默认端口 8080),浏览器打开 http://127.0.0.1:8080。

## 四个 bat 的档位

| 文件 | 上下文 | 速度 | 用途 |
|---|---|---|---|
| `4K上下文.bat` | 4096 | ~27 tok/s | 日常聊天 |
| `4K多模态.bat` | 4096 | ~27 tok/s | 发图片/截图 |
| `11K折中.bat` | 11264 | ~11.5 tok/s | 长文档,显存提交小,最稳 |
| `14K长上下文.bat` | 14336 | ~11.5 tok/s(空闲可到 ~22) | 塞最大文档 |

每次双击任意 bat 会自动关闭上一个实例(单实例架构,8080 同一时间只能跑一个)。

## 已知坑(实测本件硬记)

- 上下文别超过 14336:该二进制 16384 起解码会塌(上游问题,等新版)。
- 不要给这组 bat 加 `-ctk/-ctv` 量化 KV 参数(混合注意力下会掉到 <1 tok/s)。
- 输出一律保持 `-n 16384`:模型思考很长,上限小了会"空回答"。
- 转圈超过一分钟没出第一个字:关掉服务窗口重新双击 bat。
- 显存提交量 = 权重 + KV + 桌面程序占用;太满会触发 WDDM 分页,表现为"时快时慢"。

## Credits / 光源

- **Qwen3.8-27B**:Qwen 官方模型,Apache-2.0
- **Ternary-Bonsai-2-27B**:Prism ML 的三元权重压缩(PTQ1_0/PQ2_0, 1.75~2.13 bpw)
- **Heretic 去审查化**:OS-Software 于 HF 的 Ternary-Bonsai-2-27B-Uncensored-Heretic 分支;GSQ-RCO Heretic 量化来自 0bserverx 仓库
- **GSQ-RCO 量化方案**:IST-DASLab(arXiv 2604.18556 / 2605.00649)
- 本仓库只包含启动脚本和安装脚本,不包含权重;权重均为上游公开仓库的产物,请遵守它们各自的许可。

## License

脚本与说明:MIT。模型权重:见上游仓库(Qwen3.8-27B 本体 Apache-2.0)。
