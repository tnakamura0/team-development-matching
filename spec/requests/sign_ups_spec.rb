require "rails_helper"

RSpec.describe "SignUps", type: :request do
  let!(:user) { create(:user) }

  # ログインリクエストを送る
  def log_in(user, password: user.password)
    post session_path, params: { email_address: user.email_address, password: password }
  end

  describe "GET /sign_up" do
    context "未ログインの場合" do
      it "正常にアクセスできる" do
        get sign_up_path
        expect(response).to have_http_status(:ok)
      end
    end
    context "ログイン済みの場合" do
      before do
        log_in(user)
      end
      it "ホーム画面にリダイレクトされる" do
        get sign_up_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
  describe "POST /sign_up" do
    context "正しい入力情報の場合" do
      let(:valid_params) do
        { user: attributes_for(:user) }
      end
      it "ホーム画面にリダイレクトされる" do
        post sign_up_path, params: valid_params
        expect(response).to redirect_to(root_path)
      end
      it "ユーザーが1件作成される" do
        expect {
          post sign_up_path, params: valid_params
        }.to change(User, :count).by(1)
      end
    end
    context "名前が空白の場合" do
      let(:invalid_params) do
        { user: attributes_for(:user, name: "") }
      end
      it "アカウントが作成できない" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
    context "メールアドレスが既に存在する場合" do
      let(:invalid_params) do
        { user: attributes_for(:user, email_address: user.email_address) }
      end
      it "アカウントが作成できない" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
    context "パスワードが空白の場合" do
      let(:invalid_params) do
        { user: attributes_for(:user, password: "") }
      end
      it "アカウントが作成できない" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
    context "パスワードが8文字未満の場合" do
      let(:invalid_params) do
        { user: attributes_for(:user, password: "a" * 7) }
      end
      it "アカウントが作成できない" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
    context "パスワードと確認用パスワードが一致しない場合" do
      let(:invalid_params) do
        { user: attributes_for(:user, password_confirmation: "mismatch") }
      end
      it "アカウントが作成できない" do
        expect {
          post sign_up_path, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end
end
