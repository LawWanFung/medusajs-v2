# Stage 1: Base Builder Phase (負責所有 Apps 嘅共同依賴安裝)
# 用一個強大嘅 Base Image 嚟做 Build
FROM mcr.microsoft.com/devcontainers/typescript-node:20 AS base_builder

# 確保 package mamanger 喺 PATH
RUN corepack enable 

# 1. 設定工作目錄為 Monorepo 根目錄
WORKDIR /app

# 2. 複製所有 App 共同嘅檔案結構 
# COPY .yarn .yarn
# COPY .changeset .changeset
# COPY package.json yarn.lock turbo.json script.sh _tsconfig.base.json .yarnrc.yml ./

# 3. 複製所有 App/Packages 嘅 Source Code
# ⚠️ 注意：呢度最好係複製埋所有 source code，確保 pnpm 可以正確鏈接
# COPY packages packages
# COPY scripts scripts
# COPY www www
# COPY integration-tests integration-tests

COPY . . 

# 4. Install all dependecies
RUN yarn install --immutable

# ------------------------------------------------------------------------
# Stage 2: Base Builder Phase (負責所有 Apps 嘅共同依賴安裝)
# 用一個強大嘅 Base Image 嚟做 Build
FROM base_builder AS builder

# 確保 package mamanger 喺 PATH
# RUN corepack enable yarn

# 1. 設定工作目錄為 Monorepo 根目錄
WORKDIR /app
# 2. Build App
# RUN yarn workspaces focus --all
# RUN yarn workspace @medusajs/medusa run build
RUN yarn turbo run build --scope=@medusajs --include-dependencies

# ------------------------------------------------------------------------
# Stage 2: Runtime
FROM node:20-slim AS final

RUN corepack enable yarn

WORKDIR /app

#COPY --from=builder /app .
# Copy only medusa build artifacts + node_modules
COPY --from=builder /app/packages/medusa ./packages/medusa
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 9000

RUN script.sh

# CMD ["yarn","serve"]
CMD ["yarn", "workspace", "@medusajs/medusa", "start"]