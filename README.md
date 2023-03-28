### 環境構築
* 設定ファイルの作成

    ```
    $ cp asset/.env.{sample,develop}
    $ cp asset/.env.{sample,production}
    ```

    * 各ファイルに必要な情報を書き込む
        * .env.develop
        * .env.production

* firebaseのSDK設定ファイル作成
    * web/js/firebase.js

    ```
    const hostname = location.hostname;
    if (hostname == 'vc-space.web.app') { // production
        const firebase_config = {
            apiKey: "xxxxxxxxxxxxxxxxxxxxxxxx",
            authDomain: "vc-space.firebaseapp.com",
            projectId: "vc-space",
            storageBucket: "vc-space.appspot.com",
            messagingSenderId: "xxxxxxxxxxxxxxx",
            appId: "xxxxxxxxxxxxxxx",
            measurementId: "xxxxxxxxxxxxxxx"
        };
    } else {
        const firebase_config = {
            apiKey: "xxxxxxxxxxxxxxxxxxxxxxxx",
            authDomain: "vc-space-dev.firebaseapp.com",
            projectId: "vc-space-dev",
            storageBucket: "vc-space-dev.appspot.com",
            messagingSenderId: "xxxxxxxxxxxxxxx",
            appId: "xxxxxxxxxxxxxxx",
            measurementId: "xxxxxxxxxxxxxxx"
        };
    }
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