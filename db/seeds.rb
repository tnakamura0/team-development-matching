# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  # 開発環境用テストアカウント
  user = User.find_or_create_by!(email_address: "test@example.com") do |user|
    user.name = "テスト太郎"
    user.password = "password"
  end

  # 開発環境用募集データ
  recruitments = [
    {
      title: "Railsでチーム開発をしませんか？",
      body: "Railsを使ったWebアプリを一緒に開発するメンバーを募集しています！",
      closing_date: Date.current + 14.days,
      positions_count: 2,
      required_status: :basic_step_completed,
      accepting_applications: true
    },
    {
      title: "チーム開発メンバー募集中！",
      body: "応用ステップを完了した方とチーム開発に挑戦したいです。",
      closing_date: Date.current + 21.days,
      positions_count: 1,
      required_status: :advanced_step_completed,
      accepting_applications: true
    },
    {
      title: "卒業生同士でアプリを開発しませんか？",
      body: "卒業生で集まってWebアプリを開発しましょう！",
      closing_date: Date.current + 7.days,
      positions_count: 2,
      required_status: :graduated,
      accepting_applications: false
    }
  ]

  recruitments.each do |attributes|
    recruitment = user.recruitments.find_or_initialize_by(
      title: attributes[:title]
    )

    recruitment.assign_attributes(attributes)
    recruitment.save!
  end
end
