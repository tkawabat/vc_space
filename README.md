### 環境構築
* 設定ファイルの作成

```
$ cp asset/.env.{sample,develop}
$ cp asset/.env.{sample,production}

# 各ファイルに必要な情報を書き込む
```

## Freezedビルド
```
$ flutter pub run build_runner build --delete-conflicting-outputs
```

## リリース
* 開発

```
$ flutter build web --dart-define FLAVOR=develop --release
$ firebase use default
$ firebase deploy
```

* 本番

```
$ flutter build web --dart-define FLAVOR=production --release
$ firebase use production
$ firebase deploy
```