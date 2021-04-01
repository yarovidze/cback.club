class Contact < MailForm::Base

  attribute :email
  attribute :file, attachment: true

  attribute :message
  attribute :nickname, captcha: true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: "Нове звернення",
      to: "cback.club@gmail.com",
      from: %( <#{email}>)
    }
  end
end