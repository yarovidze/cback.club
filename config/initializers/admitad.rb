Admitad.config do |c|
  c.client_id     = Rails.application.secrets.admitad[:client_id]
  c.client_secret = Rails.application.secrets.admitad[:client_secret]
  c.scope         = Rails.application.secrets.admitad[:scope]
end