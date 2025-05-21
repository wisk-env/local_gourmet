## サービス概要
[![Image](https://github.com/user-attachments/assets/d46d4e17-44bc-4f4e-b921-f02e429a66fc)](https://local-gurume.com/)

飲食店の口コミ共有サービスです。<br>
地図や口コミから飲食店を検索できます。<br>
ユーザー登録すると、飲食店のブックマーク、お店の口コミ投稿などの機能が利用できます。

## サービスURL
https://local-gurume.com/

## 使用技術
カテゴリー | 使用技術
--- | ---
フロントエンド | HTML / CSS / JavaScript / jQuery
バックエンド | Ruby 3.3.8 / Ruby on Rails 7.1.5.1 / PostgreSQL 14.17
インフラ | Heroku / AWS S3
API | Geocoding API / Maps JavaScript API
その他ツール | Visual Studio Code / draw.io / Figma / GitHub Actions

## 機能一覧
- ユーザー登録 / ログイン / ログアウト機能 (devise)
- ゲストログイン機能
- 店舗登録 / 詳細表示機能
- 店舗検索機能 (Geocoding API / Maps JavaScript API)
- 店舗ブックマーク機能
- 口コミ投稿 /表示 / 編集 / 削除機能 (CRUD)
- 口コミ検索機能 (ransack)
- いいね機能 (Ajax)
- プロフィール編集機能
- 画像投稿機能 (Active Storage)
- レスポンシブ対応

## 工夫した点
- 本番環境での画像の読み込み速度
本番環境では口コミを表示するページの画像の読み込みが遅かったため、読み込み速度を上げるために、ImageProccessingを使用して口コミ投稿時にアップロードする画像をリサイズして保存することで、PageSpeed InsightsのSpeed Indexのスコアを0.5秒短縮 (2秒→1.5秒) しました。

## 使用イメージ
| 店舗登録 | 口コミ投稿 |
|:-----------:|:------------:|
| [![Image from Gyazo](https://i.gyazo.com/46c5b3914c34cb933a15de283e3af98a.gif)](https://gyazo.com/46c5b3914c34cb933a15de283e3af98a) | [![Image from Gyazo](https://i.gyazo.com/03099702121e8c96f0ba108fd48c4270.gif)](https://gyazo.com/03099702121e8c96f0ba108fd48c4270) |
| ユーザーが口コミを投稿したいお店が「ローカルグルメ」に登録済みか判定します。店舗が未登録の場合は、お店の名前を入力して登録します。 | ユーザーが口コミを投稿したいお店が「ローカルグルメ」に登録済みの場合は、口コミ投稿画面が表示されます。 |

</br>

| 口コミ検索 | マップ検索 |
|:-----------:|:------------:|
| [![Image from Gyazo](https://i.gyazo.com/879241ec85fb97dc5ce1245dc7ba4247.gif)](https://gyazo.com/879241ec85fb97dc5ce1245dc7ba4247) | [![Image from Gyazo](https://i.gyazo.com/0595a5dd9c3e5fd18698272b0859517b.gif)](https://gyazo.com/0595a5dd9c3e5fd18698272b0859517b) |
| ユーザーの口コミ情報をキーワードやエリア、価格帯、その他こだわり条件を基に検索できます。 | マップから登録されている店舗を検索できます。 |

## ER図
[![Image from Gyazo](https://i.gyazo.com/8b46c2a92cf8f7a218c5a49412133778.png)](https://gyazo.com/8b46c2a92cf8f7a218c5a49412133778)

## 画面遷移図
[Figma](https://www.figma.com/design/Oyd9S91vphi0PfvhBlKD70/%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB%E3%82%B0%E3%83%AB%E3%83%A1?node-id=429-39&p=f&t=boF0yFyNhmlYzMtQ-0)
