# tengen-image

[m3dev/tengen](https://github.com/m3dev/tengen) のコンテナイメージ。上流を submodule `tengen/` としてコミット単位でピン留めする。

tengen は公式コンテナイメージも npm パッケージも公開しておらず、リポジトリに Dockerfile も無いため、ここでビルドして Gitea の内蔵コンテナレジストリに push する。

## ビルドと push

**OMV 上で実行する**（Mac は arm64、OMV は amd64）。submodule が必要なので `--recurse-submodules` を付ける。

```sh
cd /tmp && rm -rf tengen-image && git clone --recurse-submodules ssh://git@gitea.yasue1014.work:8090/kijuky/tengen-image.git && cd tengen-image && TAG=gitea.yasue1014.work/kijuky/tengen:$(git -C tengen rev-parse --short=12 HEAD)-$(git rev-parse --short=7 HEAD) && docker build -t $TAG . && docker push $TAG && echo "pushed: $TAG"
```

タグは `<上流コミット12桁>-<このリポジトリのコミット7桁>`。上流のバージョンと、Dockerfile を含むビルド定義の両方が一意に特定できる。

## サブコマンド

`ENTRYPOINT` は `node src/tengen.ts` までで、サブコマンドは焼き込んでいない。`serve` を固定すると `build-malicious-db` が実行できなくなるため。

```sh
# プロキシを動かす（CMD の既定）
docker run --rm -p 3000:3000 <image>

# malicious DB を生成する（serve は --malicious-db-path に既存ファイルを要求するので、初回は先にこれ）
docker run --rm -v /path/to/data:/data <image> build-malicious-db -o /data/malicious-db.json
```

## 上流を更新する

```sh
git -C tengen fetch origin && git -C tengen checkout <new-sha> && git add tengen && git commit -m "bump tengen to <new-sha>" && git push
```

更新後に上のビルド手順を再実行する。

## 関連

- タスク: Gitea `kijuky/tasks` の issue #77
