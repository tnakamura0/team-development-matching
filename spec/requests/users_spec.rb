require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "GET /users/:id" do
    let!(:user) { create(:user, name: "テスト太郎", period: 75) }
    let!(:other_user) { create(:user, name: "テスト魚", period: 72) }

    def log_in(user, password: user.password)
      post session_path, params: { email_address: user.email_address, password: password }
    end

    context "ログイン済みの場合" do
      before do
        post session_path, params: { email_address: user.email_address, password: user.password }
      end

      it "正常にアクセスできる" do
        get user_path(user)
        expect(response).to have_http_status(:ok)
      end

      it "他のユーザーのページにアクセスできる" do
        get user_path(other_user)
        expect(response).to have_http_status(:ok)
      end

      it "ヘッダーに自分のマイページへのリンクが表示される" do
        get root_path
        expect(response.body).to include(%(href="#{user_path(user)}">マイページ</a>))
      end

      it "自分のマイページにはメールアドレスが表示される" do
        get user_path(user)
        expect(response.body).to include(user.email_address)
      end

      it "他のユーザーのマイページにはメールアドレスが表示されない" do
        get user_path(other_user)
        expect(response.body).not_to include(other_user.email_address)
      end

      it "学習ステータスが表示される" do
        get user_path(user)
        expect(response.body).to include("基礎STEP完了")
      end
    end

    context "未ログインの場合" do
      it "マイページを閲覧できる" do
        get user_path(user)
        expect(response).to have_http_status(:ok)
      end

      it "他のユーザーのメールアドレスは表示されない" do
        get user_path(other_user)
        expect(response.body).not_to include(other_user.email_address)
      end

      it "学習ステータスが表示される" do
        get user_path(user)
        expect(response.body).to include("基礎STEP完了")
      end
    end

    context "存在しないユーザーのページにアクセスした場合" do
      before do
        log_in(user)
      end

      it "404エラーが返る" do
        get user_path(id: 9999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
