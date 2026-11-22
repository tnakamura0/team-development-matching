require "rails_helper"

RSpec.describe "Users", type: :request do
  def log_in(user, password: user.password)
    post session_path, params: { email_address: user.email_address, password: password }
  end

  describe "GET /users/:id" do
    let!(:user) { create(:user, name: "テスト太郎", period: 75) }
    let!(:other_user) { create(:user, name: "テスト魚", period: 72) }

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

  describe "GET /users/:id/edit" do
    let!(:user) { create(:user, name: "テスト太郎", period: 75) }
    let!(:other_user) { create(:user) }

    context "ログイン済みの場合" do
      before do
        log_in(user)
        get edit_user_path(user)
      end

      it "編集画面が表示される" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("テスト太郎")
      end
    end

    context "他人の編集画面を開いた場合" do
      it "404になる" do
        log_in(user)
        get edit_user_path(other_user)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "ログイン画面にリダイレクトされる" do
        get edit_user_path(user)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  describe "PATCH /users/:id" do
    let!(:user) { create(:user, name: "変更前", period: 75, required_status: "graduated") }
    let!(:other_user) { create(:user, name: "他人") }
    let(:valid_params) do
      { user: { name: "変更後", period: 90, required_status: "basic_step_completed" } }
    end

    context "本人がログインしている場合" do
      before { log_in(user) }

      context "正しい内容の場合" do
        it "名前・期・ステータスが更新され、マイページに遷移する" do
          patch user_path(user), params: valid_params

          expect(response).to redirect_to(user_path(user))
          user.reload
          expect(user.name).to eq("変更後")
          expect(user.period).to eq(90)
          expect(user.required_status).to eq("basic_step_completed")
        end
      end

      context "入力に不備がある場合" do
        it "更新されず、編集画面が再表示される" do
          patch user_path(user), params: { user: { name: "", period: 60 } }

          expect(response).to have_http_status(:unprocessable_content)
          expect(user.reload.name).to eq("変更前")
        end
      end
    end

    context "他人のユーザー情報を更新しようとした場合" do
      it "404になり、更新されない" do
        log_in(user)
        patch user_path(other_user), params: valid_params

        expect(response).to have_http_status(:not_found)
        expect(other_user.reload.name).to eq("他人")
      end
    end
  end
end
