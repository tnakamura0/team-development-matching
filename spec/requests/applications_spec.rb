require "rails_helper"

RSpec.describe "Applications", type: :request do
  def log_in(user, password: user.password)
    post session_path, params: {
      email_address: user.email_address,
      password: password
    }
  end

  let(:owner) { create(:user) }
  let(:other_user) { create(:user, name: "応募太郎") }
  let!(:recruitment) { create(:recruitment, user: owner, positions_count: 3) }

  describe "POST /recruitments/:recruitment_id/applications" do
    subject(:apply) { post recruitment_applications_path(recruitment) }

    context "未ログインの場合" do
      it "応募は作成されず、ログイン画面にリダイレクトされる" do
        expect { apply }.not_to change(Application, :count)
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "募集者以外でログインしている場合" do
      before { log_in(other_user) }

      it "pendingの応募が作成される" do
        expect { apply }.to change(Application, :count).by(1)
        expect(Application.last.user).to eq(other_user)
        expect(Application.last.status).to eq("pending")
      end

      it "募集詳細画面に戻り、完了メッセージが表示される" do
        apply
        expect(response).to redirect_to(recruitment_path(recruitment))

        follow_redirect!
        expect(response.body).to include("応募しました")
      end

      context "すでに同じ募集に応募済みの場合" do
        before { create(:application, recruitment:, user: other_user) }

        it "応募は作成されない" do
          expect { apply }.not_to change(Application, :count)
        end
      end
    end

    context "募集者本人がログインしている場合" do
      before { log_in(owner) }

      it "リクエストを直接送っても応募は作成されない" do
        expect { apply }.not_to change(Application, :count)
      end
    end
  end

  describe "PATCH /recruitments/:recruitment_id/applications/:id/approve" do
    subject(:approve) { patch approve_recruitment_application_path(recruitment, application) }

    let!(:application) { create(:application, recruitment:, user: other_user) }

    context "未ログインの場合" do
      it "状態は変わらず、ログイン画面にリダイレクトされる" do
        approve
        expect(application.reload.status).to eq("pending")
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "募集者本人の場合" do
      before { log_in(owner) }

      it "approvedになり、完了メッセージが表示される" do
        approve
        expect(application.reload.status).to eq("approved")
        expect(response).to redirect_to(recruitment_path(recruitment))

        follow_redirect!
        expect(response.body).to include("承認しました")
      end

      context "残り枠が0の場合" do
        before do
          recruitment.update!(positions_count: 1)
          create(:application, recruitment:, status: "approved")
        end

        it "承認されず、エラーメッセージが表示される" do
          approve
          expect(application.reload.status).to eq("pending")
          expect(response).to redirect_to(recruitment_path(recruitment))

          follow_redirect!
          expect(response.body).to include("残り枠がないため承認できません")
        end
      end
    end

    context "募集者以外の場合" do
      before { log_in(create(:user)) }

      it "状態は変わらず、404になる" do
        approve
        expect(application.reload.status).to eq("pending")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PATCH /recruitments/:recruitment_id/applications/:id/reject" do
    subject(:reject) { patch reject_recruitment_application_path(recruitment, application) }

    let!(:application) { create(:application, recruitment:, user: other_user) }

    context "未ログインの場合" do
      it "状態は変わらず、ログイン画面にリダイレクトされる" do
        reject
        expect(application.reload.status).to eq("pending")
        expect(response).to redirect_to(new_session_path)
      end
    end

    context "募集者本人の場合" do
      before { log_in(owner) }

      it "rejectedになり、完了メッセージが表示される" do
        reject
        expect(application.reload.status).to eq("rejected")
        expect(response).to redirect_to(recruitment_path(recruitment))

        follow_redirect!
        expect(response.body).to include("見送りました")
      end
    end

    context "募集者以外の場合" do
      before { log_in(create(:user)) }

      it "状態は変わらず、404になる" do
        reject
        expect(application.reload.status).to eq("pending")
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /recruitments/:id（応募の表示）" do
    subject(:body) do
      get recruitment_path(recruitment)
      response.body
    end

    let(:apply_form_path) { recruitment_applications_path(recruitment) }

    context "承認済みの応募がある場合" do
      before do
        create(:application, recruitment:, status: "approved")
        create(:application, recruitment:, status: "pending")
      end

      it "承認数が表示される" do
        expect(body).to include("1名承認済み")
      end
    end

    context "未ログインの場合" do
      before { create(:application, recruitment:, user: other_user) }

      it "応募ボタンは押せず、ログインを促す文言が表示される" do
        expect(body).to include("応募するには")
        expect(body).not_to include(apply_form_path)
      end

      it "応募者一覧が表示されない" do
        expect(body).not_to include("応募太郎")
      end
    end

    context "募集者本人の場合" do
      before { log_in(owner) }

      it "応募ボタンが表示されない" do
        expect(body).not_to include(apply_form_path)
        expect(body).not_to include("応募済み")
      end

      context "応募がない場合" do
        it "専用の文言が表示される" do
          expect(body).to include("現在、応募がありません。")
        end
      end

      context "応募がある場合" do
        let!(:pending_application) { create(:application, recruitment:, user: other_user, status: "pending") }
        let!(:approved_application) { create(:application, recruitment:, user: create(:user, name: "花子"), status: "approved") }
        let!(:rejected_application) { create(:application, recruitment:, user: create(:user, name: "次郎"), status: "rejected") }

        it "応募者の名前と期が表示される" do
          expect(body).to include("応募太郎")
          expect(body).to include("花子")
          expect(body).to include("次郎")
          expect(body).to include("◯期")
        end

        it "承認待ちの応募者に確認ダイアログ付きの有効な承認ボタンが表示される" do
          document = Nokogiri::HTML(body)

          button = document.at_css(
            "form[action='#{approve_recruitment_application_path(recruitment, pending_application)}'] button"
          )

          expect(button).not_to be_nil
          expect(button.has_attribute?("disabled")).to be false
          expect(body).to include("応募太郎さんを承認しますか？")
        end

        it "承認待ちの応募者に確認ダイアログ付きのお見送りボタンが表示される" do
          expect(body).to include(reject_recruitment_application_path(recruitment, pending_application))
          expect(body).to include("応募太郎さんを見送りますか？")
        end

        it "承認済み、見送り済みの応募者にはボタンの代わりに状態が表示される" do
          expect(body).not_to include(approve_recruitment_application_path(recruitment, approved_application))
          expect(body).not_to include(reject_recruitment_application_path(recruitment, rejected_application))
          expect(body).to include("承認")
          expect(body).to include("お見送り")
        end

        context "残り枠が0の場合" do
          before { recruitment.update!(positions_count: 1) }

          it "承認ボタンが無効になる" do
            document = Nokogiri::HTML(body)

            button = document.at_css(
              "form[action='#{approve_recruitment_application_path(recruitment, pending_application)}'] button"
            )

            expect(button).not_to be_nil
            expect(button.has_attribute?("disabled")).to be true
          end

          it "お見送りボタンは表示される" do
            expect(body).to include(reject_recruitment_application_path(recruitment, pending_application))
          end
        end
      end
    end

    context "募集者以外でログインしている場合" do
      before { log_in(other_user) }

      it "確認ダイアログ付きの応募ボタンが表示される" do
        expect(body).to include(apply_form_path)
        expect(body).to include("この募集に応募しますか？")
      end

      context "他のユーザーの応募がある場合" do
        before { create(:application, recruitment:, user: create(:user, name: "承認花子")) }

        it "応募者一覧が表示されない" do
          expect(body).not_to include("承認花子")
          expect(body).not_to include("現在、応募はありません")
        end
      end

      context "応募済みの場合" do
        before { create(:application, recruitment:, user: other_user) }

        it "応募ボタンの代わりに押せない応募済みボタンが表示される" do
          expect(body).to include("応募済み")
          expect(body).not_to include(apply_form_path)
        end

        it "自分の応募の承認状況がpendingと表示される" do
          expect(body).to include("pending")
        end
      end

      context "自分の応募がapprovedの場合" do
        before { create(:application, recruitment:, user: other_user, status: "approved") }

        it "承認状況がapprovedと表示される" do
          expect(body).to include("approved")
        end
      end

      context "自分の応募がrejectedの場合" do
        before { create(:application, recruitment:, user: other_user, status: "rejected") }

        it "承認状況がrejectedと表示される" do
          expect(body).to include("rejected")
        end
      end
    end
  end
end
