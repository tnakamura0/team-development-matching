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
        expect(application.errors[:user]).to be_present
      end
    end
  end
end
