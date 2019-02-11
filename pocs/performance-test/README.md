
# FIWAREサーバの構築

## dockerのインストール

公式手順に従いインストールを行う
https://docs.docker.com/install/linux/docker-ce/ubuntu/

### インストール手順

パッケージインデックスを更新

```
sudo apt-get update
```

HTTPS経由でリポジトリを使用できるようにするためのパッケージをインストール

```
sudo apt-get install \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common
```

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Dockerの公式GPGキーを追加

```
sudo apt-key fingerprint 0EBFCD88
```

フィンガープリント9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88の最後の8文字を検索して、フィンガープリントを持つキーが手元にあることを確認

```
sudo add-apt-repository \
 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) \
 stable"
```

パッケージインデックスを更新

```
sudo apt-get update
```

リポジトリで利用可能なバージョンを一覧表示

```
apt-cache madison docker-ce
```

docker-ce=18.06.1~ce~3-0~ubuntuバージョンをインストール

```
sudo apt-get install docker-ce=18.06.1~ce~3-0~ubuntu
```

dockerグループを作成

```
sudo groupadd docker
```

自分のユーザーをdockerグループに追加

```
sudo usermod -aG docker $USER
```

ログアウトし再ログイン後バージョンの確認

```
$ docker --version
Docker version 18.06.1-ce, build e68fc7a
```

## docker-composeのインストール

公式手順に従いインストールを行う
https://docs.docker.com/compose/install/#install-compose

### インストール手順

特定バージョンのDocker Composeをダウンロード

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

実行可能権限をバイナリに適用

```
sudo chmod +x /usr/local/bin/docker-compose
```

/usr/binパスにシンボリックリンクの作成

```
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

バージョンの確認

```
$ docker-compose --version
docker-compose version 1.22.0, build f46880fe
```

## 負荷試験スクリプトを実行するために必要なパッケージのインストール

- sysstat
- iotop
- jq
- mosquitto-clients

```
sudo apt install sysstat iotop jq mosquitto-clients
```

## ログ取得に必要な設定

### dockerのAPIを有効化

/lib/systemd/system/docker.serviceの[ExecStart=/usr/bin/dockerd -H fd://]を[ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2376]に書き換える

```
sudo vim /lib/systemd/system/docker.service
```

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## gitのクローン

```
git clone https://github.com/oolorg/fiware-poc.git
```

---


# 擬似デバイスサーバの構築

負荷試験用疑似デバイスコンテナを起動するための負荷試験用サーバ(ubuntu)を物理または仮想で用意する。

## dockerのインストール

[[FIWAREサーバの構築]の[dockerのインストール]](#dockerのインストール)手順に従いdockerのインスールを行う

## 負荷試験用のVMを起動するために必要なパッケージのインストール

- jq
- sysstat
- bc

```
sudo apt install jq sysstat bc
```

## gitのクローン

```
git clone https://github.com/oolorg/fiware-poc.git
```

## 疑似デバイス用コンテナイメージのビルド

### 送信データが文字列のコンテナ

```
cd fiware-poc/pocs/publish_container_startup_interval
docker build . -t dummy_device_startup_interval
```

### 送信データが数値のコンテナ

```
cd fiware-poc/pocs/publish_container_startup_interval_number
docker build . -t dummy_device_startup_interval_number
```