# Stage 1: Base Builder Phase (負責所有 Apps 嘅共同依賴安裝)
# 用一個強大嘅 Base Image 嚟做 Build
FROM mcr.microsoft.com/devcontainers/typescript-node:16 AS base_builder

# 確保 package mamanger 喺 PATH
RUN corepack enable 

# 1. 設定工作目錄為 Monorepo 根目錄
WORKDIR .

# 2. 複製所有 App 共同嘅檔案結構 
COPY .yarn .yarn
COPY .changeset .changeset
COPY package.json yarn.lock turbo.json script.sh  .yarnrc.yml .

RUN ls -la
RUN ls -la .yarn/patches

# 3. 複製所有 App/Packages 嘅 Source Code
# ⚠️ 注意：呢度最好係複製埋所有 source code，確保 pnpm 可以正確鏈接
COPY packages ./packages
COPY scripts ./scripts
COPY www ./www
COPY integration-tests ./integration-tests

# 4. Install all dependecies
RUN yarn install --immutable --immutable-cache

# ------------------------------------------------------------------------
# Stage 2: Base Builder Phase (負責所有 Apps 嘅共同依賴安裝)
# 用一個強大嘅 Base Image 嚟做 Build
FROM base_builder AS builder

# 確保 package mamanger 喺 PATH
# RUN corepack enable yarn

# 1. 設定工作目錄為 Monorepo 根目錄
WORKDIR /app
# 2. Build App
RUN yarn workspace packages/medusa run build

# ------------------------------------------------------------------------
# Stage 2: Runtime
FROM node:16-slim AS final

RUN corepack enable yarn

WORKDIR /app

COPY --from=builder /app .

EXPOSE 9000

CMD ["yarn","serve"]