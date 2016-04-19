#!/bin/sh

# 時刻設定を行う
if [ ! -e /etc/localtime/Japan ]; then
    cp -p /usr/share/zoneinfo/Japan /etc/localtime
fi

# confファイルの差分を確認するための保存用のディレクトリを作成する
if [ ! -e /var/old_conf_files ]; then
    mkdir /var/old_conf_files
fi

# ntpサーバーのインストールを行う
if [ ! -e /etc/init.d/ntpd ]; then
    yum -y install ntp
    ntpdate ntp.nict.jp
fi
# 以前設定したntp.confファイルが存在するなら差分を調べ、そうでないなら新しく設定を行う
if [ -e /var/old_conf_files/ntp.conf ]; then
    # 差分があるなら設定を変更して再起動を行う
    diff=`diff /var/conf_files/ntp.conf /var/old_conf_files/ntp.conf`
    if [ -n "$diff" ]; then
        cp /var/conf_files/ntp.conf /etc/ntp.conf
        cp /var/conf_files/ntp.conf /var/old_conf_files/ntp.conf
        service ntpd restart
    fi
    #差分がない場合何もしない
else
    # 新しくntp.confファイルを設定する
    cp /var/conf_files/ntp.conf /etc/ntp.conf
    cp /var/conf_files/ntp.conf /var/old_conf_files/ntp.conf
    # ntpサーバーの起動と自動起動設定を行う
    service ntpd start
    chkconfig ntpd on
fi

# apacheのインストールと設定
if [ ! -e /etc/init.d/httpd ]; then
    yum -y install httpd
fi
# 以前設定したhttpd.confファイルが存在するなら差分を調べ、そうでないなら新しく設定を行う
if [ -e /var/old_conf_files/httpd.conf ]; then
    # 差分があるなら設定を変更して再起動を行う
    diff=`diff /var/conf_files/httpd.conf /var/old_conf_files/httpd.conf`
    if [ -n "$diff" ]; then
        cp /var/conf_files/httpd.conf /etc/httpd/conf/httpd.conf
        cp /var/conf_files/httpd.conf /var/old_conf_files/httpd.conf
        service httpd restart
    fi
    #差分がない場合何もしない
else
    # 新しくhttpd.confファイルを設定する
    cp /var/conf_files/httpd.conf /etc/httpd/conf/httpd.conf
    cp /var/conf_files/httpd.conf /var/old_conf_files/httpd.conf
    # apacheの起動と自動起動設定を行う
    service httpd start
    chkconfig httpd on
fi

