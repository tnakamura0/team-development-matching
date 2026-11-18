require "rails_helper"

RSpec.describe "Applications", type: :request do
  def log_in(user, password: user.password)
    post session_path, params: {
      email_address: user.email_address,
      password: password
    }
  end

  let(:owner) { create(:user) }
  let(:other_user) { create(:user, name: "応募太郎") }
  let!(:recruitment) { create(:recruitment, user: owner, positions_count: 3) }

  describe "POST /recruitments/:recruitment_id/applications" do
    subject(:apply) { post recruitment_applications_path(recruitment) }

    context "未ログインの場合" do
      it "応募は作成されず、ログイン画面にリダイレクトされる" do
        expect { apply }.not_to change(Application, :count)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "募集者以外でログインしている場合" do
      before { log_in(other_user) }

      it "pendingの応募が作成される" do
        expect { apply }.to change(Application, :count).by(1)
        expect(Application.last.user).to eq(other_user)
        expect(Application.last.status).to eq("pending")
      end

      it "募集詳細画面に戻り、完了メッセージが表示される" do
        apply
        expect(response).to redirect_to(recruitment_path(recruitment))

        follow_redirect!
        expect(response.body).to include("応募しました")
      end

      context "すでに同じ募集に応募済みの場合" do
        before { create(:application, recruitment:, user: other_user) }

        it "応募は作成されない" do
          expect { apply }.not_to change(Application, :count)
        end
      end
    end

    context "募集者本人がログインしている場合" do
      before { log_in(owner) }

      it "リクエストを直接送っても応募は作成されない" do
        expect { apply }.not_to change(Application, :count)
      end
    end
  end

  describe "GET /recruitments/:id（応募の表示）" do
    subject(:body) do
      get recruitment_path(recruitment)
      response.body
    end

    let(:apply_form_path) { recruitment_applications_path(recruitment) }

    context "承認済みの応募がある場合" do
      before do
        create(:application, recruitment:, status: "approved")
        create(:application, recruitment:, status: "pending")
      end

      it "承認数と残り人数が表示される" do
        expect(body).to include("1 / 3人(残り2名)")
      end
    end

    context "応募がない場合" do
      it "専用の文言が表示される" do
        expect(body).to include("現在、応募はありません")
      end
    end

    context "応募がある場合" do
      before do
        create(:application, recruitment:, user: other_user, status: "pending")
        create(:application, recruitment:, user: create(:user, name: "承認花子"), status: "approved")
      end

      it "応募者の名前と承認状況が表示される" do
        expect(body).to include("応募太郎：未承認")
        expect(body).to include("承認花子：承認済み")
      end
    end

    context "未ログインの場合" do
      it "応募ボタンは押せず、ログインを促す文言が表示される" do
        expect(body).to include("応募するには")
        expect(body).not_to include(apply_form_path)
      end
    end

    context "募集者本人の場合" do
      before { log_in(owner) }

      it "応募ボタンが表示されない" do
        expect(body).not_to include(apply_form_path)
        expect(body).not_to include("応募済み")
      end
    end

    context "募集者以外でログインしている場合" do
      before { log_in(other_user) }

      it "確認ダイアログ付きの応募ボタンが表示される" do
        expect(body).to include(apply_form_path)
        expect(body).to include("この募集に応募しますか？")
      end

      context "応募済みの場合" do
        before { create(:application, recruitment:, user: other_user) }

        it "応募ボタンの代わりに押せない応募済みボタンが表示される" do
          expect(body).to include("応募済み")
          expect(body).not_to include(apply_form_path)
        end
      end
    end
  end
end
