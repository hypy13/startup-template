FROM node:22-bookworm-slim AS base
ENV PNPM_HOME="/pnpm" PATH="/pnpm:$PATH"
RUN corepack enable
WORKDIR /repo
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY apps/web/package.json apps/web/package.json
RUN pnpm install --frozen-lockfile
COPY apps/web apps/web

FROM base AS development
CMD ["pnpm", "--filter", "@startup/web", "dev"]

FROM base AS production
ENV NODE_ENV=production NEXT_TELEMETRY_DISABLED=1 API_INTERNAL_URL=http://api:8000
RUN pnpm --filter @startup/web build
USER node
CMD ["pnpm", "--filter", "@startup/web", "start"]
