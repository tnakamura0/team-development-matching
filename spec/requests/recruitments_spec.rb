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
end
