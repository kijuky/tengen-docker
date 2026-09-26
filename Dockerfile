# src/*.ts は Node のネイティブ型ストリッピングで直接実行する。
# 無フラグで動くのは Node >= 22.18 / 23.6。
FROM node:24-alpine

WORKDIR /app
COPY tengen/package.json tengen/package-lock.json ./
RUN npm ci --omit=dev
COPY tengen/ ./

# サブコマンドを焼き込むと build-malicious-db が実行できなくなる。
ENTRYPOINT ["node", "src/tengen.ts"]

# tengen の既定バインドは 127.0.0.1 なので、コンテナでは上書きする。
CMD ["serve", "--host", "0.0.0.0", "--port", "3000"]
