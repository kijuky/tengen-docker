# m3dev/tengen のコンテナイメージ。
# 上流は submodule `tengen/` としてコミット単位でピン留めしている。
# tengen 自身は公式イメージも npm パッケージも持たず、Dockerfile も同梱していないため
# ここでビルドする。src/*.ts は Node のネイティブ型ストリッピングで直接実行する
# （無フラグで動くのは Node >= 22.18 / 23.6）。
FROM node:24-alpine

WORKDIR /app
COPY tengen/package.json tengen/package-lock.json ./
RUN npm ci --omit=dev
COPY tengen/ ./

# 既定は 127.0.0.1 バインドなのでコンテナでは 0.0.0.0 が必須
ENTRYPOINT ["node", "src/tengen.ts", "serve", "--host", "0.0.0.0", "--port", "3000"]
