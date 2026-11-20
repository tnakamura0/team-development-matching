require "rails_helper"

RSpec.describe Application, type: :model do
  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:recruitment) { create(:recruitment)  }
    subject(:application) do
      build(:application, user: user, recruitment: recruitment)
    end

    context "全ての属性が有効な場合" do
      it "有効である" do
        expect(application).to be_valid
      end
    end

    context "userが紐づいていない場合" do
      before { application.user = nil }

      it "無効である" do
        expect(application).to be_invalid
        expect(application.errors[:user]).to be_present
      end
    end

    context "recruitmentが紐づいていない場合" do
      before { application.recruitment = nil }

      it "無効である" do
        expect(application).to be_invalid
        expect(application.errors[:recruitment]).to be_present
      end
    end

    context "同じユーザーが同じ募集に応募した場合" do
      before do
        create(
          :application,
          user: application.user,
          recruitment: application.recruitment
        )
      end

      it "無効である" do
        expect(application).to be_invalid
        expect(application.errors[:user_id]).to be_present
      end
    end

    context "募集作成者本人が応募した場合" do
      before { application.user = application.recruitment.user }

      it "無効である" do
        expect(application).to be_invalid
        expect(application.errors[:base]).to include("募集作成者のため応募できません")
      end
    end

    context "応募締切日がすぎた場合" do
      let!(:existing_application) do
        create(:application, recruitment: recruitment)
      end
      before do
        recruitment.update!(closing_date: Date.current - 1.day)
      end

      it "既存の応募ステータスは更新できる" do
        existing_application.status = "approved"
        expect(existing_application).to be_valid
      end
    end
  end
  describe "#approve" do
    let(:recruitment) { create(:recruitment, positions_count: 1) }
    let(:application) { create(:application, recruitment:) }

    context "承認待ちで残り枠がある場合" do
      it "approvedになりtrueを返す" do
        expect(application.approve).to be true
        expect(application.reload.status).to eq("approved")
      end
    end

    context "残り枠が0の場合" do
      before { create(:application, recruitment:, status: "approved") }

      it "approvedにならずエラーが追加される" do
        expect(application.approve).to be false
        expect(application.reload.status).to eq("pending")
        expect(application.errors[:base]).to include("残り枠がないため承認できません")
      end
    end

    context "承認待ち以外の場合" do
      before { application.update!(status: "rejected") }

      it "状態が変わらずエラーが追加される" do
        expect(application.approve).to be false
        expect(application.reload.status).to eq("rejected")
        expect(application.errors[:base]).to include("この応募はすでに処理済みです")
      end
    end
  end

  describe "#reject" do
    let(:application) { create(:application) }

    context "承認待ちの場合" do
      it "rejectedになりtrueを返す" do
        expect(application.reject).to be true
        expect(application.reload.status).to eq("rejected")
      end
    end

    context "承認待ち以外の場合" do
      before { application.update!(status: "approved") }

      it "状態が変わらずエラーが追加される" do
        expect(application.reject).to be false
        expect(application.reload.status).to eq("approved")
        expect(application.errors[:base]).to include("この応募はすでに処理済みです")
      end
    end
  end

  describe "eunm" do
    it "statusが定義されている" do
      expect(Application.statuses).to eq(
        "pending" => "pending",
        "approved" => "approved",
        "rejected" => "rejected"
      )
    end
  end
end
