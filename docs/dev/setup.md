# 開発環境の構築

このリポジトリを手元のパソコンで動かし、テストが通る状態にするまでの手順です。
上から順番に進めれば完了します。

> Ruby や PostgreSQL をパソコンに直接インストールする必要はありません。
> アプリもデータベースも Docker のコンテナの中で動きます。パソコンに入れるのは Docker と Git だけです。

## ゴール

- ブラウザで http://localhost:3000 を開くとアプリの画面が表示される
- テスト（RSpec）がすべて成功する

## 最初に知っておくとよい言葉

| 言葉 | ざっくりした意味 |
|---|---|
| ターミナル | コマンドを打ち込んで操作する画面 |
| Docker | アプリを動かす環境を「コンテナ」という箱にまとめて動かす道具 |
| コンテナ | このプロジェクトでは web（アプリ）・db（データベース）を使う |

## 1. リポジトリを手元にコピーする（clone）

```bash
$ git clone git@github.com:tnakamura0/team-development-matching.git
$ cd team-development-matching
```

## 3. 起動する

```bash
$ docker compose build                              # 初回のみ
$ docker compose run --rm web bin/rails db:prepare  # 初回のみ
$ docker compose up -d
```

ターミナルでコンテナの起動を確認する。
- dbコンテナ：`database system is ready to accept connections`
- webコンテナ（開発サーバー）：`Listening on http://0.0.0.0:3000`

## 4. テストを動かす

```bash
$ docker compose run --rm web bundle exec rspec
$ docker compose run --rm web bin/rubocop
```

`0 failures`（テスト）と `no offenses detected`（RuboCop）が出れば、環境構築は完了です。

## 5. 毎日の作業の始め方

```bash
$ git switch main
$ git pull
$ docker compose up -d
```

| `git pull` で変わったファイル | やること |
|---|---|
| `Gemfile` / `Gemfile.lock` | `docker compose build` → `docker compose up -d` |
| `Dockerfile` / `compose.yaml` | `docker compose build` → `docker compose up -d` |
| `db/migrate/`配下 | `docker compose run --rm web bin/rails db:prepare` |

## 6. よく使うコマンド

| やりたいこと | コマンド |
|---|---|
| アプリを起動 | `docker compose up -d` |
| アプリを停止 | `docker compose stop` |
| ログを見る | `docker compose logs -f web` |
| テストを実行 | `docker compose run --rm web bundle exec rspec` |
| 書き方の自動修正 | `docker compose run --rm web bin/rubocop -a` |
| セキュリティ診断 | `docker compose run --rm web bin/brakeman` |
| Rails コンソール | `docker compose run --rm web bin/rails console` |
| ローカルCI実行 | `docker compose run --rm web bin/ci` |

## 7. うまくいかないとき
| 症状 | 原因と対処 |
|---|---|
| `Cannot connect to the Docker daemon` | Docker Desktop が起動していない。起動してから、もう一度実行する |
| `port is already allocated` | 別のアプリが 3000 番ポートを使っている。そのアプリを止める |
| `ActiveRecord::PendingMigrationError` | `docker compose run --rm web bin/rails db:prepare` を実行する |

### それでも解決しないとき
30分調べても解決しなければ、Discord の相談・質問 で質問してください。
エラーメッセージは、スクリーンショットではなく文字をコピーして貼ります。
