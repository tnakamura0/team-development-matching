require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let(:user) { create(:user) }

  # ログインリクエストを送る
  def log_in(user, password: user.password)
    post session_path, params: { email_address: user.email_address, password: password }
  end

  describe "GET /session/new" do
    context "未ログインの場合" do
      before { get new_session_path }

      it "正常にアクセスできる" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
        get new_session_path
      end

      it "ホーム画面にリダイレクトされる" do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "POST /session" do
    context "正しい認証情報の場合" do
      before { log_in(user) }

      it "ホーム画面にリダイレクトされる" do
        expect(response).to redirect_to(root_path)
      end

      it "ログイン成功のメッセージが表示される" do
        follow_redirect!
        expect(response.body).to include("ログインしました")
      end
    end

    context "パスワードが誤っている場合" do
      before { log_in(user, password: "wrong") }

      it "ログイン画面にリダイレクトされる" do
        expect(response).to redirect_to(new_session_path)
      end

      it "共通のエラーメッセージが表示される" do
        follow_redirect!
        expect(response.body).to include("メールアドレスまたはパスワードが正しくありません")
      end
    end
  end

  describe "DELETE /session" do
    context "ログイン済みの場合" do
      before do
        log_in(user)
        delete session_path
      end

      it "ホーム画面にリダイレクトされる" do
        expect(response).to redirect_to(root_path)
      end

      it "ログアウト成功のメッセージが表示される" do
        follow_redirect!
        expect(response.body).to include("ログアウトしました")
      end
    end
  end

  describe "GET /" do
    context "未ログインの場合" do
      before { get root_path }

      it "ログアウトボタンが表示されない" do
        expect(response.body).not_to include("ログアウト</button>")
      end
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
        get root_path
      end

      it "ログアウトボタンが表示される" do
        expect(response.body).to include("ログアウト</button>")
      end
    end
  end
end
