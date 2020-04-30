class UserMailer < ApplicationMailer
  def confirm_email
    user = params[:user]
    @url = params[:root_url] + 'verify-email?token=' + params[:token]
    mail(to: user.email, subject: "이메일 주소를 인증해주세요").tap do |message|
      message.mailgun_options = {
          "tag" => ["abtest-option-a", "beta-user"],
          "tracking-opens" => true,
          "tracking-clicks" => "htmlonly"
      }
    end
  end

  def password_reset_email
    user = params[:user]
    @url = params[:root_url] + 'password-reset?token=' + params[:token]
    mail(to: user.email, subject: "비밀번호를 다시 설정해주세요").tap do |message|
      message.mailgun_options = {
          "tag" => ["abtest-option-a", "beta-user"],
          "tracking-opens" => true,
          "tracking-clicks" => "htmlonly"
      }
      end
  end
end
