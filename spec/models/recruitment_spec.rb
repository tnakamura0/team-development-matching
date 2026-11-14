require "rails_helper"

RSpec.describe Recruitment, type: :model do
  describe "バリデーション" do
    subject(:recruitment) { build(:recruitment) }

    context "全ての属性が有効な場合" do
      it "有効である" do
        expect(recruitment).to be_valid
      end
    end

    context "titleが空の場合" do
      before { recruitment.title = "" }

      it "無効である" do
        expect(recruitment).to be_invalid
        expect(recruitment.errors[:title]).to be_present
      end
    end

    context "closing_dateが空の場合" do
      before { recruitment.closing_date = nil }

      it "無効である" do
        expect(recruitment).to be_invalid
        expect(recruitment.errors[:closing_date]).to be_present
      end
    end

    context "positions_countが空の場合" do
      before { recruitment.positions_count = nil }

      it "無効である" do
        expect(recruitment).to be_invalid
        expect(recruitment.errors[:positions_count]).to be_present
      end
    end

    context "positions_countが正の数の場合" do
      context "整数の場合" do
        before { recruitment.positions_count = 1 }

        it "有効である" do
          expect(recruitment).to be_valid
        end
      end

      context "小数の場合" do
        before { recruitment.positions_count = 0.1 }

        it "無効である" do
          expect(recruitment).to be_invalid
          expect(recruitment.errors[:positions_count]).to eq([ "must be an integer" ])
        end
      end
    end

    context "positions_countが0以下の場合" do
      before { recruitment.positions_count = 0 }

      it "無効である" do
        expect(recruitment).to be_invalid
        expect(recruitment.errors[:positions_count]).to eq([ "must be greater than 0" ])
      end
    end

    context "required_statusが空の場合" do
      before { recruitment.required_status = nil }

      it "無効である" do
        expect(recruitment).to be_invalid
        expect(recruitment.errors[:required_status]).to be_present
      end
    end

    context "accepting_applicationsが空の場合" do
      before { recruitment.accepting_applications = nil }

      it "無効である" do
        expect(recruitment).to be_invalid
        expect(recruitment.errors[:accepting_applications]).to be_present
      end
    end
  end

  describe "デフォルト値" do
    it "新規作成直後の募集が募集中となる" do
      recruitment = Recruitment.new

      expect(recruitment.accepting_applications).to be true
    end
  end

  describe "アソシエーション" do
    it "ユーザーを削除すると関連する募集も削除される" do
      user = create(:user)
      recruitment = create(:recruitment, user:)

      expect {
        user.destroy!
      }.to change(User, :count).by(-1)

      expect(Recruitment.exists?(recruitment.id)).to be false
    end
  end

  describe "#owned_by?" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:recruitment) { create(:recruitment, user:) }

    context "投稿者本人の場合" do
      it "trueを返す" do
        expect(recruitment.owned_by?(user)).to be true
      end
    end

    context "投稿者以外のユーザーの場合" do
      it "falseを返す" do
        expect(recruitment.owned_by?(other_user)).to be false
      end
    end

    context "ユーザーがnilの場合" do
      it "falseを返す" do
        expect(recruitment.owned_by?(nil)).to be false
      end
    end
  end
end
