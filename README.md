# Exam

## 利用するツールとバージョン

- [Vagrant](https://www.vagrantup.com/): 1.8.1
- [VirtualBox](https://www.virtualbox.org/): 5.0.16 r105871

利用する端末にすでに上記ツールがインストール済みの場合は、バージョンが上記と同じ、もしくはそれ以降のものであることを確認してください.

## Vagrant について

### VM の起動/プロビジョニング

```
$ cd /path/to/repos/01
$ vagrant up
```

### VM の破棄

```
$ cd /path/to/repos/01
$ vagrant destroy
```

上記以外のコマンドや情報については、

```
$ vagrant help
```

や

[公式ドキュメント](https://www.vagrantup.com/docs/)を参照してください.
