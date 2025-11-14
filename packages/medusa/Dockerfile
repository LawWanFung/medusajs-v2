# Stage 1: Base Builder Phase (負責所有 Apps 嘅共同依賴安裝)
# 用一個強大嘅 Base Image 嚟做 Build
FROM mcr.microsoft.com/devcontainers/typescript-node:16 AS base_builder

# 確保 package mamanger 喺 PATH
RUN corepack enable 

# 1. 設定工作目錄為 Monorepo 根目錄
WORKDIR /app

# 2. 複製所有 App 共同嘅檔案結構 
COPY package.json yarn.lock turbo.json script.sh .

# 3. 複製所有 App/Packages 嘅 Source Code
# ⚠️ 注意：呢度最好係複製埋所有 source code，確保 pnpm 可以正確鏈接
COPY packages /app/packages
COPY scripts /app/scripts
COPY www /app/www
COPY integration-tests /appl/integration-tests

# 4. 創建 pnpm-store 目錄並授權 (為咗 cache mount 準備)
RUN mkdir -p /app/.pnpm-store \
    && chown -R node:node /app/.pnpm-store

# 5. 安裝所有 Apps 嘅依賴！呢個係最費時嘅步驟，只做一次。
# pnpm install 會設置好所有 Apps 需要嘅 node_modules 鏈接
RUN --mount=type=cache,id=pnpm,target=/app/.pnpm-store \
    pnpm install --frozen-lockfile

# 呢個 Base Stage 已經有晒所有 dependencies。
# 之後你所有嘅 App Dockerfile (e.g., stripe/Dockerfile) 只需要用 'FROM base_builder' 開始，
# 然後直接跑 'pnpm --filter <app-name> run build' 就得，唔使再 install！