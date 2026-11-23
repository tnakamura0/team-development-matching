# TODO: #103 パスワード再設定はMVP対象外のため無効化。routes有効化時に使用
class PasswordsMailer < ApplicationMailer
  def reset(user)
    @user = user
    mail subject: "Reset your password", to: user.email_address
  end
end
