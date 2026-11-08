require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  # ログインリクエストを送る
  def log_in(user, password: user.password)
    post session_path, params: { email_address: user.email_address, password: password }
  end

  describe "GET /session/new" do
    it "正常にアクセスできるか" do
      get new_session_path
      expect(response).to have_http_status(200)
    end

    it "ログイン済みならホーム画面にリダイレクトされる" do
      log_in(user)
      get new_session_path
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST /session" do
    it "正しい認証情報ならホーム画面にリダイレクトされる" do
      log_in(user)
      expect(response).to redirect_to(root_path)
    end

    it "ログイン成功のメッセージが表示される" do
      log_in(user)
      follow_redirect!
      expect(response.body).to include("ログインしました")
    end

    it "誤ったパスワードならログイン画面にリダイレクトされる" do
      log_in(user, password: "wrong")
      expect(response).to redirect_to(new_session_path)
    end

    it "ログイン失敗時は共通のエラーメッセージが表示される" do
      log_in(user, password: "wrong")
      follow_redirect!
      expect(response.body).to include("メールアドレスまたはパスワードが正しくありません")
    end
  end

  describe "DELETE /session" do
    it "ログアウトできる" do
      log_in(user)
      delete session_path
      expect(response).to redirect_to(root_path)
    end

    it "ログアウト成功のメッセージが表示される" do
      log_in(user)
      delete session_path
      follow_redirect!
      expect(response.body).to include("ログアウトしました")
    end
  end

  describe "GET /" do
    it "未ログイン時はログアウトボタンが表示されない" do
      get root_path
      expect(response.body).not_to include("ログアウト</button>")
    end

    it "ログイン時はログアウトボタンが表示される" do
      log_in(user)
      get root_path
      expect(response.body).to include("ログアウト</button>")
    end
  end
end
