# Exam 06

## ゴール

以下の要件を満たす VM を構築してください.

### VM/ミドルウェアの要件

- VM は http://localhost:8080 で HTTP リクエストを待ち受ける
- VM のポート 8080 への HTTP リクエストはポート 80 で待ち受ける Nginx にフォワードされる
- Nginx へのリクエストは PHP-FPM で動作する [WordPress](https://ja.wordpress.org/) へと送られる
- ただし、 http://localhost:8080/healthcheck へのリクエストはPHP-FPMには流さず、 Nginx で 200 OK となるレスポンスを返す

---

- Nginx, PHP-FPM はそれぞれ別の Docker コンテナとして動作する
- WordPress のデータストレージである MySQL はホストマシンに直接インストールしても良い

---

- コンテナの起動は docker-compose を用いて行う

### アプリケーションの要件

- WordPress は app ディレクトリ以下に展開し、ホスト側での変更が VM/Docker コンテナにダイレクトに反映されるようにする(=マウントする)

### 時間がある場合の追加作業

- MySQL を Docker コンテナとして動かし、VM を再起動しても停止前のデータが永続化されたままの状態であるようにする

この追加作業の提出は、別ブランチ/別PRでお願いします.