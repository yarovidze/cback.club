::Liqpay.configure do |config|
  config.public_key = Rails.application.credentials.liqpay[:public_key]
  config.private_key = Rails.application.credentials.liqpay[:private_key]
end