class UserMailer < ApplicationMailer
  def confirm_email
    user = params[:user]
    @url = "http://localhost:3000" + '/verify-email?token=' + params[:token]
    mail(to: user.email, subject: "이메일 주소를 인증해주세요").tap do |message|
      message.mailgun_options = {
          "tag" => ["abtest-option-a", "beta-user"],
          "tracking-opens" => true,
          "tracking-clicks" => "htmlonly"
      }
    end
  end
end
