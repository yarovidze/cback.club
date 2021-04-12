class Contact < MailForm::Base

  attribute :email, validate: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  attribute :file, attachment: true
  attribute :message, validate: true
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