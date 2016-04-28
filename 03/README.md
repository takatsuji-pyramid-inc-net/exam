# Exam 03

## ゴール

Exam 01 の Vagrantfile を利用して構築された VM が http://localhost:5001 を通して Web アプリケーションを公開しています.

以下の要件を満たすものを提出してください.

```
$ vagrant up
```
で VM を起動すると、BASIC 認証なしで Web アプリケーションにアクセスできる.

```
$ BASIC_AUTH_USER=xxx BASIC_AUTH_PASS=yyy vagrant up
```
で VM を起動すると、xxx/yyy で Web アプリケーションに BASIC 認証が設定される.

また、BASIC 認証のあり/なしは VM の再起動だけで切り替わる(=再provisionは不要)ようにしてください.

講師側で動作確認ができるよう、提出時はコメント欄に VM 起動時のコマンドを明示してください.

## 注意事項

今回の Vagrantfile はホストマシンと VM のファイル共有方法として NFS を利用しているため、起動時/終了時などにホストマシンの管理者権限が要求されます.
