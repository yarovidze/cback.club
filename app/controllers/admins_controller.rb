class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create_json(request)
    raw_json = JSON.generate(request)
    raw_json = JSON.parse raw_json.gsub('=>', ':')
    JSON(raw_json)
  end

  def withdrawal_get
    data_req = params[:data]
    sing_req = params[:signature]
    signature = base64_encode( sha1( 'sandbox_Y9YPYGvIQrweilaQTrUKc80c86a3zvNpkNhyJMH9' + data_req + 'sandbox_Y9YPYGvIQrweilaQTrUKc80c86a3zvNpkNhyJMH9') )
    (sing_req == signature) ? sing_corect = "444444444444444444444" : sing_corect = "555555555555555555555"
    Transaction.create(user_id: 1, action_id: sing_corect.to_i, offer_id: 1, status: 3, cashback_percent: 2 ).save
    data_raw = Base64.decode64(data_req)
    data = create_json(data_raw.force_encoding('utf-8'))
    rec_withdrawal(data)
  end

  def rec_withdrawal(data)
    Transaction.create(user_id: 1, action_id: "33333333333333".to_i, offer_id: 1, status: 3, cashback_percent: 2).save
    @transaction = Transaction.create(user_id: 1, action_id: "2222222222".to_i, offer_id: 1, status: 3, cashback_percent: 2).save
    @transaction.offer_id = "1"
    @transaction.status = "0"
    @transaction.total = data["amount"]
    @transaction.cashback_sum = data["amount"]
    @transaction.user_id = "1"
  end

end
