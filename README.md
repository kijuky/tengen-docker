# tengen-image

[m3dev/tengen](https://github.com/m3dev/tengen) のコンテナイメージ。上流を submodule `tengen/` としてコミット単位でピン留めする。

tengen は公式コンテナイメージも npm パッケージも公開しておらず、リポジトリに Dockerfile も無いため、ここでビルドして Gitea の内蔵コンテナレジストリに push する。

## ビルドと push

**OMV 上で実行する**（Mac は arm64、OMV は amd64）。submodule が必要なので `--recurse-submodules` を付ける。

```sh
cd /tmp && rm -rf tengen-image && git clone --recurse-submodules ssh://git@gitea.yasue1014.work:8090/kijuky/tengen-image.git && cd tengen-image && TAG=gitea.yasue1014.work/kijuky/tengen:$(git -C tengen rev-parse --short=12 HEAD) && docker build -t $TAG . && docker push $TAG && echo "pushed: $TAG"
```

タグは submodule が指す上流コミットの短縮 SHA になるので、イメージと上流ソースが 1:1 で対応する。

## 上流を更新する

```sh
git -C tengen fetch origin && git -C tengen checkout <new-sha> && git add tengen && git commit -m "bump tengen to <new-sha>" && git push
```

更新後に上のビルド手順を再実行する。

## 関連

- タスク: Gitea `kijuky/tasks` の issue #77
