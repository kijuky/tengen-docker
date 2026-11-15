# tengen-docker

[m3dev/tengen](https://github.com/m3dev/tengen) のコンテナイメージ。tengen は公式イメージも npm パッケージも Dockerfile も公開していないため、ここでビルドする。

上流は submodule `tengen/` としてコミット単位でピン留めする。現在はフォーク [kijuky/tengen](https://github.com/kijuky/tengen) の `develop`（`--registry` によるレジストリの宣言、Maven・Ivy のグループ、`Last-Modified` によるタイムスタンプ判定、公開 URL、ダウンロードのキャッシュ）。上流に取り込まれたら `.gitmodules` の url を `m3dev/tengen` に戻す。

## イメージ

```
ghcr.io/kijuky/tengen:<上流コミット12桁>-<このリポジトリのコミット7桁>
```

タグは上流のバージョンとビルド定義の両方を一意に示す。Dockerfile だけを変えた場合もタグが変わる。`linux/amd64` と `linux/arm64`。

`main` への push と `workflow_dispatch` で [publish ワークフロー](.github/workflows/publish.yml)がビルドして push する。publish されたタグは job summary に出る。

## 使い方

```sh
# プロキシを動かす（CMD の既定）
docker run --rm -p 3000:3000 ghcr.io/kijuky/tengen:<tag>

# malicious DB を生成する
docker run --rm -v /path/to/data:/data ghcr.io/kijuky/tengen:<tag> \
  build-malicious-db -o /data/malicious-db.json
```

`ENTRYPOINT` にサブコマンドを焼き込んでいないため、`serve` と `build-malicious-db` のどちらも実行できる。`serve --malicious-db-path` は既存ファイルを要求するので、初回は `build-malicious-db` が先。

## 上流を更新する

```sh
git -C tengen fetch origin && git -C tengen checkout <new-sha> && git add tengen && git commit -m "bump tengen to <new-sha>" && git push
```

push するとワークフローが新しいタグで publish する。
