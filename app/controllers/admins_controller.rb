class AdminsController < ApplicationController

  def create_json(request)
    raw_json = JSON.generate(request)
    raw_json = JSON.parse raw_json.gsub('=>', ':')
    JSON(raw_json)
  end

  def withdrawal_get
    data_req = params[:data]
    sing_req = params[:signature]
    sing_req == signature
    signature = base64_encode( sha1( 'sandbox_Y9YPYGvIQrweilaQTrUKc80c86a3zvNpkNhyJMH9' + data_req + 'sandbox_Y9YPYGvIQrweilaQTrUKc80c86a3zvNpkNhyJMH9') )
    data_raw = Base64.decode64(data_req)
    data = create_json(data_raw.force_encoding('utf-8'))
    rec_withdrawal(data)
  end

  def rec_withdrawal(data)
    transaction_params = params.permit(:offer_id, :status, :total, :cashback_sum, :user_id, :action_id)
    @transaction = Transaction.create(transaction_params)
    @transaction.offer_id = "1"
    @transaction.status = "0"
    @transaction.total = data["amount"]
    @transaction.cashback_sum = data["amount"]
    @transaction.user_id = "1"
    @transaction.action_id = data["order_id"]
  end

end
