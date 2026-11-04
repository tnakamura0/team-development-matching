# データ設計

## ER図

<p align="center">
  <img src="er-diagram.drawio.svg" alt="ER Diagram" style="padding: 25px; background-color: #ffffff; width: 100%;">
</p>

## テーブル設計

### users

ユーザー情報を管理する。

| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| id | bigint | null: false, unique: true | 主キー |
| name | string | null: false | ユーザー名 |
| email | string | null: false | メールアドレス |
| password_digest | string | null: false | ハッシュ化したパスワード |
| created_at | datetime | null: false | 作成日時 |
| updated_at | datetime | null: false | 更新日時 |

### recruitments

募集内容を管理する。

| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| id | bigint | null: false, unique: true | 主キー |
| user_id | bigint | null: false, foreign_key: true | 外部キー（募集を作成したユーザー） |
| closing_date | date | null: false | 締切日 |
| recruitment_limit | integer | null: false | 募集人数 |
| dev_status | string | null: false | 応募者の状態 |
| created_at | datetime | null: false | 作成日時 |
| updated_at | datetime | null: false | 更新日時 |

### applications

募集への応募を管理する。

| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| id | bigint | null: false, unique: true | 主キー |
| user_id | bigint | null: false, foreign_key: true | 外部キー（応募したユーザー） |
| recruitment_id | bigint | null: false, foreign_key: true | 外部キー（応募先の募集） |
| created_at | datetime | null: false | 作成日時 |
| updated_at | datetime | null: false | 更新日時 |

### notifications

応募後に募集者に届く通知を管理する。

| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| id | bigint | null: false, unique: true | 主キー |
| user_id | bigint | null: false, foreign_key: true | 外部キー（通知を受け取るユーザー: 募集者） |
| application_id | bigint | null: false, foreign_key: true | 外部キー（通知原因の応募） |
| created_at | datetime | null: false | 作成日時 |
| updated_at | datetime | null: false | 更新日時 |
