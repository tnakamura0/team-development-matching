require "rails_helper"

RSpec.describe "Recruitments", type: :request do
  describe "GET /recruitments" do
    context "募集が0件の場合" do
      it "専用の文言が表示される" do
        get recruitments_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("現在募集がありません")
      end
    end

    context "募集が1件以上ある場合" do
      let!(:old_recruitment) { create(:recruitment, title: "古い募集", created_at: 2.days.ago) }
      let!(:new_recruitment) { create(:recruitment, title: "新しい募集", created_at: 1.days.ago) }

      it "募集が新しい順に表示される" do
        get recruitments_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to match(/新しい募集.*古い募集/m)
      end
    end
  end

  describe "DELETE /recruitments/:id" do
    def log_in(user, password: user.password)
      post session_path, params: { email_address: user.email_address, password: password }
    end

    let!(:owner) { create(:user) }
    let!(:own_recruitment) { create(:recruitment, user: owner) }
    let!(:other_recruitment) { create(:recruitment) }

    context "投稿者が本人の場合" do
      before { log_in(owner) }

      it "募集が1件削除される" do
        expect { delete recruitment_path(own_recruitment) }.to change(Recruitment, :count).by(-1)
      end

      it "募集一覧画面にリダイレクトされる" do
        delete recruitment_path(own_recruitment)
        expect(response).to have_http_status(:see_other)
        expect(response).to redirect_to(recruitments_path)
      end

      it "削除成功のメッセージが表示される" do
        delete recruitment_path(own_recruitment)
        follow_redirect!
        expect(response.body).to include("募集を削除しました")
      end
    end

    context "投稿者が他人の場合" do
      before { log_in(owner) }

      it "募集が削除されない" do
        expect { delete recruitment_path(other_recruitment) }.not_to change(Recruitment, :count)
      end

      it "404が返る" do
        delete recruitment_path(other_recruitment)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "未ログインの場合" do
      it "募集が削除されない" do
        expect { delete recruitment_path(own_recruitment) }.not_to change(Recruitment, :count)
      end

      it "ログイン画面にリダイレクトされる" do
        delete recruitment_path(own_recruitment)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
