class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'liqpay'
  def create_json(request)
    raw_json = JSON.generate(request)
    raw_json = JSON.parse raw_json.gsub('=>', ':')
    JSON(raw_json)
  end

  def withdrawal_get
    data = params[:data]
    signature = params[:signature]
    liqpay = Liqpay.new
    #signature_my = base64_encode( sha1( 'sandbox_Y9YPYGvIQrweilaQTrUKc80c86a3zvNpkNhyJMH9' + data_req + 'sandbox_Y9YPYGvIQrweilaQTrUKc80c86a3zvNpkNhyJMH9') )
    Trial.create(name: 'liqpay_sing',
                 test_field1: signature.to_s,
                 test_field2: data.to_s).save
    Trial.create(name: 'liqpay_sing_correct?',
                 test_field1: liqpay.match?(data, signature),
                 test_field2: liqpay.decode_data(data)).save
    #data_raw = liqpay.decode_data(data)
    #data_j = create_json(data_raw.force_encoding('utf-8'))
    #rec_withdrawal(data_j)
  end

  def rec_withdrawal(data)
    Transaction.create(user_id: 1, action_id: "33333333333333".to_i, offer_id: 1, status: 3, cashback_sum: 2).save
    @transaction = Transaction.create(user_id: 1, action_id: "2222222222".to_i, offer_id: 1, status: 3, cashback_sum: 2).save
    @transaction.offer_id = "1"
    @transaction.status = "0"
    @transaction.total = data["amount"]
    @transaction.cashback_sum = data["amount"]
    @transaction.user_id = "1"
  end

end
