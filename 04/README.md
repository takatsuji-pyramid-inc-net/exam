# Exam 04

## ゴール

Exam 01 の Vagrantfile を利用して構築された VM が http://localhost:5001 を通して Web アプリケーションを公開しています.

この VM に [Fluentd](http://www.fluentd.org/) をセットアップし、Apache のアクセスログ/エラーログを app/logs ディレクトリ以下に出力してください.

## 注意事項

今回の Vagrantfile はホストマシンと VM のファイル共有方法として NFS を利用しているため、起動時/終了時などにホストマシンの管理者権限が要求されます.
