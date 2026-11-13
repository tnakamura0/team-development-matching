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

  describe "POST /recruitments" do
    let(:user) { create(:user) }
    def log_in(user, password: user.password)
      post session_path, params: { email_address: user.email_address, password: password }
    end

    context "ログイン済みの場合" do
      before do
        log_in(user)
      end
      context "正しい内容が入力された場合" do
        it "募集が作成され、詳細画面に遷移する" do
          expect {
            post recruitments_path, params: {
              recruitment: attributes_for(:recruitment)
            }
          }.to change(Recruitment, :count).by(1)

          expect(response).to redirect_to(recruitment_path(Recruitment.last))
        end
      end

      context "入力に不備がある場合" do
        it "募集が作成されず、新規作成画面が再表示する" do
          expect {
            post recruitments_path, params: {
              recruitment: attributes_for(:recruitment, title: nil)
            }
          }.not_to change(Recruitment, :count)

          expect(response).to have_http_status(:unprocessable_content)
          expect(response.body).to include("タイトルが未入力です")
        end
      end
      context "他のユーザーのIDが指定された場合" do
        let(:another_user) { create(:user) }

        it "ログインユーザーに募集が紐づくこと" do
          post recruitments_path, params: {
            recruitment: attributes_for(:recruitment).merge(user_id: another_user.id)
          }

          expect(Recruitment.last.user).to eq(user)
        end
      end
    end
  end

  describe "GET /recruitments/new" do
    context "未ログインの場合" do
      it "ログイン画面にリダイレクトする" do
        get new_recruitment_path
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
