require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "バリデーション" do
    let(:application) { create(:application) }
    subject(:notification) { build(:notification, application: application) }

    context "全ての属性が有効な場合" do
      it "有効である" do
        expect(notification).to be_valid
      end
    end

    context "recipientが紐づいていない場合" do
      before { notification.recipient = nil }

      it "無効である" do
        expect(notification).to be_invalid
        expect(notification.errors[:recipient]).to be_present
      end
    end

    context "applicationが紐づいていない場合" do
      before { notification.application = nil }

      it "無効である" do
        expect(notification).to be_invalid
        expect(notification.errors[:application]).to be_present
      end
    end

    context "actionが定義されていない値の場合" do
      before { notification.action = "invalid" }

      it "無効である" do
        expect(notification).to be_invalid
        expect(notification.errors[:action]).to be_present
      end
    end

    context "同じ応募で同じactionの通知がある場合" do
      before { create(:notification, application: application, action: "applied") }

      it "無効である" do
        expect(notification).to be_invalid
        expect(notification.errors[:action]).to be_present
      end
    end

    context "同じ応募で違うactionの通知がある場合" do
      before { create(:notification, application: application, action: "approved") }

      it "有効である" do
        expect(notification).to be_valid
      end
    end
  end

  describe "scope" do
    describe ".unread" do
      let!(:unread_notification) { create(:notification) }
      let!(:read_notification) { create(:notification, read_at: Time.current) }

      it "未読の通知のみ取得する" do
        expect(Notification.unread).to eq([ unread_notification ])
      end
    end

    describe ".recent" do
      let!(:old_notification) { create(:notification, created_at: 1.day.ago) }
      let!(:new_notification) { create(:notification, created_at: Time.current) }

      it "新しい順に取得する" do
        expect(Notification.recent).to eq([ new_notification, old_notification ])
      end
    end
  end

  describe "関連付けの削除" do
    let!(:notification) { create(:notification) }

    context "recipientを削除した場合" do
      it "通知も削除される" do
        expect { notification.recipient.destroy }.to change(Notification, :count).by(-1)
      end
    end

    context "applicationを削除した場合" do
      it "通知も削除される" do
        expect { notification.application.destroy }.to change(Notification, :count).by(-1)
      end
    end
  end

  describe "enum" do
    it "actionが定義されている" do
      expect(Notification.actions).to eq(
        "applied" => "applied",
        "approved" => "approved",
        "rejected" => "rejected"
      )
    end
  end
end
