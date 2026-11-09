require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション" do
    subject(:user) { build(:user) }

    context "全ての属性が有効な場合" do
      it "有効である" do
        expect(user).to be_valid
      end
    end

    describe "メールアドレス" do
      context "空の場合" do
        before { user.email_address = "" }

        it "無効である" do
          expect(user).to be_invalid
          expect(user.errors[:email_address]).to be_present
        end
      end

      context "同じメールアドレスが存在する場合" do
        before { create(:user, email_address: user.email_address) }

        it "無効である" do
          expect(user).to be_invalid
          expect(user.errors[:email_address]).to be_present
        end
      end

      context "大文字小文字だけが異なるメールアドレスが存在する場合" do
        before { create(:user, email_address: user.email_address.upcase) }

        it "無効である" do
          expect(user).to be_invalid
          expect(user.errors[:email_address]).to be_present
        end
      end

      context "形式が不正な場合" do
        before { user.email_address = "user" }

        it "無効である" do
          expect(user).to be_invalid
          expect(user.errors[:email_address]).to be_present
        end
      end

      context "前後に空白があり大文字を含む場合" do
        before do
          user.email_address = "  USER@Example.com "
          user.save!
        end

        it "空白が除かれ小文字で保存される" do
          expect(user.email_address).to eq "user@example.com"
        end
      end
    end

    describe "パスワード" do
      context "空の場合" do
        before { user.password = nil }

        it "無効である" do
          expect(user).to be_invalid
          expect(user.errors[:password]).to be_present
        end
      end

      context "8文字未満の場合" do
        before { user.password = "a" * 7 }

        it "無効である" do
          expect(user).to be_invalid
          expect(user.errors[:password]).to be_present
        end
      end
    end
  end
end
