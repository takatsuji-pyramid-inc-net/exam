# Exam 07

## ゴール

以下の要件を満たす VM を構築してください.

### VM/ミドルウェアの要件

- VM は http://localhost:8080 で HTTP リクエストを待ち受ける
- VM のポート 8080 への HTTP リクエストはポート 80 で待ち受ける Nginx にフォワードされる
- Nginx へのリクエストは PHP-FPM で動作する [WordPress](https://ja.wordpress.org/) へと送られる
- ただし、 http://localhost:8080/healthcheck へのリクエストはPHP-FPMには流さず、 Nginx で 200 OK となるレスポンスを返す

---

- Nginx, PHP-FPM, MySQL はそれぞれ別の Docker コンテナとして動作する
- **WordPressのインストール終了後に VM を再起動しても、停止前の MySQL のデータは永続化されたままの状態であるようにする**

---

- コンテナの起動は docker-compose を用いて行う

### アプリケーションの要件

- WordPress は app ディレクトリ以下に展開し、ホスト側での変更が VM/Docker コンテナにダイレクトに反映されるようにする(=マウントする)
