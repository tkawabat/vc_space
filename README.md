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
$ flutter build web --dart-define FLAVOR=develop --web-renderer html --release
$ firebase use default
$ firebase deploy

# ワンライナー
$ flutter build web --dart-define FLAVOR=develop --web-renderer html --release && firebase use default && firebase deploy
```

* 本番

```
$ flutter build web --dart-define FLAVOR=production --web-renderer html --release
$ firebase use production
$ firebase deploy
```

## 運用
* メンテモード
    * envファイルのMAINTENANCEに値を入れてリリース

    ```
    MAINTENANCE="メンテナンス中です。\n終了見込み: 2/28 10:00"
    ```

    * メンテ終わったら値を消して再リリース
        * ダブルコーテーションも消す

    ```
    MAINTENANCE=
    ```