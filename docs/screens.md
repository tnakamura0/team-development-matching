# 画面設計

## 画面一覧
| ID | 画面名 | URL | ログイン | 対応UC |
|---|---|---|---|---|
| S-1 | ログイン | `/session/new` | 不要 | UC-3 |
| S-2 | 新規登録 | `registration/new` | 不要 | UC-3 |
| S-3 | 応募一覧（ホーム） | `/` | 不要 | UC-2 |
| S-4 | 応募作成・編集 | `/recruits/new`ほか | 必要 | UC-5 |
| S-5 | 応募詳細 | `/recruits/:id` | 不要 | UC-1, UC-2, UC-4 |
| S-6 | 通知一覧 | `/notifications` | 必要 | UC-6 |

## 画面遷移図

```mermaid
flowchart TD
    subgraph before["ログイン前"]
        A["S-1<br>ログイン画面"]
        B["S-2<br>新規登録画面"]
    end

    subgraph after["ログイン後"]
        C["S-3<br>応募一覧（ホーム）"]
        D["S-4<br>応募作成"]
        E["S-5<br>応募詳細"]
        F["S-6<br>通知一覧"]
    end

    A -->|ログイン成功| C
    A <--> B
    B --> C
    C <--> D
    C <--> E
    C <--> F
    D --> |作成完了| E
    D <--> F
    E <--> F
```
