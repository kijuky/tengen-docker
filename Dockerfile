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

# ENTRYPOINT にサブコマンドを焼き込まない。
# tengen には `serve` と `build-malicious-db` の 2 つのサブコマンドがあり、
# `serve` を固定すると後者を実行できなくなる。
ENTRYPOINT ["node", "src/tengen.ts"]

# 既定は serve。コンテナでは 127.0.0.1 ではなく 0.0.0.0 にバインドする必要がある。
CMD ["serve", "--host", "0.0.0.0", "--port", "3000"]
