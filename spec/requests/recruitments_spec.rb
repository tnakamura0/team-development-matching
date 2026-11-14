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

  describe "GET /recruitments/:id" do
    # ログインリクエストを送る
    def log_in(user, password: user.password)
      post session_path, params: { email_address: user.email_address, password: password }
    end

    let(:owner) { create(:user) }
    let!(:recruitment) { create(:recruitment, user: owner, title: "募集タイトル", body: "募集本文") }

    context "未ログインの場合" do
      before { get recruitment_path(recruitment) }

      it "募集の詳細が表示される" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("募集タイトル")
        expect(response.body).to include("募集本文")
      end

      it "編集、削除ボタンが表示されない" do
        expect(response.body).not_to include("編集")
        expect(response.body).not_to include("削除")
      end
    end

    context "投稿者本人がログインしている場合" do
      before do
        log_in(owner)
        get recruitment_path(recruitment)
      end

      it "募集の詳細が表示される" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("募集タイトル")
        expect(response.body).to include("募集本文")
      end

      it "編集、削除ボタンが表示される" do
        expect(response.body).to include("編集")
        expect(response.body).to include("削除")
      end
    end

    context "投稿者以外のユーザーがログインしている場合" do
      let!(:other_user) { create(:user) }
      before do
        log_in(other_user)
        get recruitment_path(recruitment)
      end

      it "募集の詳細が表示される" do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("募集タイトル")
        expect(response.body).to include("募集本文")
      end

      it "編集、削除ボタンが表示されない" do
        expect(response.body).not_to include("編集")
        expect(response.body).not_to include("削除")
      end
    end

    context "存在しない募集の場合" do
      it "404になる" do
        get recruitment_path(id: 9999)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
