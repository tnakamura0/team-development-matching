require 'rails_helper'

RSpec.describe User, type: :model do
  it "有効なファクトリを持つ" do
    expect(build(:user)).to be_valid
  end

  describe "メールアドレス" do
    context "必須項目" do
      it "空文字なら無効" do
        user = build(:user, email_address: "")
        expect(user).to be_invalid
        expect(user.errors[:email_address]).to be_present
      end
    end

    context "一意性" do
      it "同じメールアドレスが存在するなら無効" do
        create(:user, email_address: "user@example.com")
        user = build(:user, email_address: "user@example.com")
        expect(user).to be_invalid
        expect(user.errors[:email_address]).to be_present
      end

      it "大文字小文字を区別せず無効になる" do
        create(:user, email_address: "USER@example.com")
        user = build(:user, email_address: "user@example.com")
        expect(user).to be_invalid
        expect(user.errors[:email_address]).to be_present
      end
    end

    context "形式" do
      it "不正形式は無効になる" do
        user = build(:user, email_address: "user")
        expect(user).to be_invalid
        expect(user.errors[:email_address]).to be_present
      end
    end

    context "正規化" do
      it "前後の空白を除き小文字で保存される" do
        user = create(:user, email_address: "  USER@Example.com ")
        expect(user.email_address).to eq "user@example.com"
      end
    end
  end

  describe "Password" do
    context "必須項目" do
      it "空文字なら無効" do
        user = build(:user, password: "")
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end
    end

    context "形式" do
      it "8文字未満は無効" do
        user = build(:user, password: "passpas")
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end
    end
  end
end
