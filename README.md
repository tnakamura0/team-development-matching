# <プロダクト名>

RUNTEQ で学習中の「チーム開発をしたい人」が、チーム開発のメンバーを募集したり、ほかの人の募集に応募することができるアプリです。
意欲のある仲間が誰なのか分からない、個別に声をかけるしかない、という状況をなくし、募集要項を示したうえでメンバーを集められることを目指しています。

## はじめての方へ

開発に参加する方は、次の順番で進めてください。

1. **[開発環境の構築](docs/dev/setup.md)（準備中）** — Docker と Git の準備から、アプリの起動・テストの実行まで
2. **[開発の進め方](docs/dev/first-contribution.md)（準備中）** — Issue の選び方、ブランチ、コミット、Pull Request を出すまで
3. **[キックオフ資料](docs/kickoff.md)** — プロダクトの目的、チームの役割、開発ルール

困ったら Discord サーバーの「#相談・質問」テキストチャンネルで質問してください。

## タスク管理

| リンク | 内容 |
|---|---|
| [カンバン（GitHub Projects）](https://github.com/users/tnakamura0/projects/9) | Issue の状況（Backlog / Ready / In Progress / Review / Done）。着手する Issue はここの Ready 列から選ぶ |
| [マイルストーン](https://github.com/tnakamura0/team-development-matching/milestones) | MVP までのマイルストーンと期限 |
| [エピック一覧](https://github.com/tnakamura0/team-development-matching/issues?q=is%3Aissue+label%3Aepic) | MVP までの大きな要件（エピック）と進み具合 |

## クイックスタート

Docker Desktop と Git が入っていれば、次のコマンドで起動できます（詳しくは [開発環境の構築](docs/dev/setup.md)（準備中））。

```bash
git clone git@github.com:tnakamura0/team-development-matching.git
cd team-development-matching
docker compose build
docker compose run --rm web bin/rails db:prepare
docker compose up -d
```

http://localhost:3000 を開きます。停止は `docker compose stop` です。

| 画面 | URL |
|---|---|
| 募集一覧（ホーム） | http://localhost:3000/ |
| 募集の作成 | http://localhost:3000/recruits/new |
| 募集の詳細 | http://localhost:3000/recruits/1 |
| 通知一覧 | http://localhost:3000/notifications |
| 会員登録 | http://localhost:3000/registration/new |
| ログイン | http://localhost:3000/session/new |

## よく使うコマンド

Rails のコマンドは、パソコンで直接ではなく `docker compose run --rm web` を付けてコンテナの中で実行します。

| 用途 | コマンド |
|---|---|
| テスト | `docker compose run --rm web bundle exec rspec` |
| コードの書き方チェック | `docker compose run --rm web bin/rubocop` |
| セキュリティ診断 | `docker compose run --rm web bin/brakeman` |
| ログを見る | `docker compose logs -f web` |
| CSS を作り直す | `docker compose run --rm css bin/rails tailwindcss:build` |

ほかのコマンドとトラブル対処は [開発環境の構築](docs/dev/setup.md)（準備中） にまとめています。

## ドキュメント

### 仕様

| ドキュメント | 内容 |
|---|---|
| [キックオフ資料](docs/kickoff.md) | 目的とゴール、チームの役割、スケジュール、技術スタック、開発フロー、テスト方針、タスク管理、コミュニケーション |
| [要件定義](docs/requirements.md) | ペルソナ、ユースケース、ユーザーストーリー、受入条件 |
| [画面設計](docs/screens.md) | 画面一覧、画面遷移図 |
| [データ設計](docs/data-model.md)（準備中） | ER 図、テーブル定義 |

### 開発者向け

| ドキュメント | 内容 |
|---|---|
| [開発環境の構築](docs/dev/setup.md)（準備中） | 必要なもの、起動、テスト、毎日の始め方、トラブル対処 |
| [開発の進め方](docs/dev/first-contribution.md)（準備中） | Issue → ブランチ → 実装 → コミット → Pull Request の手順 |

## 技術スタック

Ruby 3.4.12 / Ruby on Rails 8.1.4 / PostgreSQL 17 / Hotwire（Turbo・Stimulus）/ Tailwind CSS v4 / RSpec / RuboCop / Docker Compose

## ディレクトリ構成（主なもの）

```text
app/
  models/                  データとそのルール
  controllers/             画面ごとの処理
  views/                   画面の HTML（ERB）
  services/                複数のモデルにまたがる処理、外部サービスの呼び出し
  javascript/controllers/  画面の動き（Stimulus）
config/routes.rb           URL と処理の対応
spec/                      テスト（RSpec）
docs/                      仕様書
docs/dev/                  開発者向けガイド
```
