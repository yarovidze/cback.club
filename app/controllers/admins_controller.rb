class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'liqpay'


  def withdrawal_get
    data = params[:data]
    signature = params[:signature]
    liqpay = Liqpay.new
    if liqpay.match?(data, signature)
    Trial.create(name: 'liqpay_sing_correct?',
                 test_field1: liqpay.match?(data, signature),
                 test_field2: liqpay.decode_data(data)).save
    rec_withdrawal(decode_data(data))
    end
  end

  def rec_withdrawal(data)
    interim_transaction = Transaction.where(action_id: data["order_id"])
    user = User.find(interim_transaction.user_id)
    Trial.create(name: 'rec_withdrawal test',
                 test_field1: interim_transaction.action_id.to_s,
                 test_field2: user.id.to_s).save
    transactions_open = user.transactions.where(status: 0)
    if transactions_open.sum(:total) == data["amount"].to_f
      transactions_open.each do |trans|
        trans.first.status = 4
        trans.save
      end
    end


    #Transaction.create(user_id: 1, action_id: "33333333333333".to_i, offer_id: 1, status: 3, cashback_sum: 2).save
    #@transaction = Transaction.create(user_id: 1, action_id: "2222222222".to_i, offer_id: 1, status: 3, cashback_sum: 2).save
    #@transaction.offer_id = "1"
    #@transaction.status = "0"
    #@transaction.total = data["amount"]
    #@transaction.cashback_sum = data["amount"]
    #@transaction.user_id = "1"
  end

end
