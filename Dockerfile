# Stage 1: Base Builder Phase (負責所有 Apps 嘅共同依賴安裝)
# 用一個強大嘅 Base Image 嚟做 Build
FROM ./Dockerfile AS builder

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


# 呢個 Base Stage 已經有晒所有 dependencies。
# 之後你所有嘅 App Dockerfile (e.g., stripe/Dockerfile) 只需要用 'FROM base_builder' 開始，
# 然後直接跑 'pnpm --filter <app-name> run build' 就得，唔使再 install！