# frozen_string_literal: true

class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'liqpay'

  def index; end

  # @return [access_token value]
  def auth_admitad
    @admitad = AdmitadService.new
    if !params[:code].nil?
      @response = @admitad.get_admitad_access_token(request.base_url + request.path, params[:code])
      cookies[:refresh_token] = @response['refresh_token'] unless @response['refresh_token'].nil?
      cookies[:access_token] = @response['access_token'] unless @response['refresh_token'].nil?
    else redirect_to @admitad.get_admitad_code
    end
    render :index
  end

  # redirect to rec method if all params correct
  def admitad_action_data
    @admitad = AdmitadService.new
    @action_data = @admitad.get_admitad_action_data(params[:start_data], params[:token])
    if correct_admitad_token? && @action_data.present?
      rec_user_actions(@action_data['results'])
    else
      redirect_to @admitad.get_admitad_code
    end
  end

  # rec admidat users actions
  # @param [clients_action_data]
  def rec_user_actions(clients_action_data)
    # if status aproved count users for whitdrawl and all sum
    @users_count = clients_action_data.count
    @all_sum = 0
    @ready_to_withdrawal = 0
    @error_transactions = []
    clients_action_data.each do |client|
      next if client['subid'] == ''

      # on production absent user with id 4
      client['subid'] = 'approved' if client['subid'].paid?
      @client = User.find_by(id: client['subid'].to_i)
      next if @client.nil?
      transaction_params = params.permit(:offer_id, :status, :total, :cashback_sum).merge(user_id: @client.id,
                                                                                          action_id: client['id'])

      @transaction = Transaction.find_by(transaction_params.except(:status, :total))
      @offer = Offer.find_by(name: client['advcampaign_name'])
      # check if new transaction or old
      unless @transaction.present?
        @transaction = Transaction.create(transaction_params.merge(total: client['payment_sum_open']))
        @transaction.action_id = client['id']
        @transaction.action_date = client['action_date']
      end
      # if transaction paid do next element in loop
      next if @transaction.status == 'paid'

      # rec or change taransaction data
      @transaction.total = client['cart']
      @transaction.status = client['status']
      @ready_to_withdrawal += 1 if client['status'] == 'approved'
      @transaction.offer_id = @offer.id
      @transaction.cashback_sum = client['payment']
      @all_sum += client['payment']
      @error_transactions.push([client['id'], action]) unless @transaction.save
    end
    render 'admins/_rec_actions_result'
  end

  # liqpay
  def withdrawal_get
    data = params[:data]
    signature = params[:signature]
    liqpay = Liqpay.new
    rec_withdrawal(liqpay.decode_data(data)) if liqpay.match?(data, signature)
  end

  def rec_withdrawal(data)
    interim_transaction = Transaction.find_by(action_id: data['order_id'].to_i)
    if interim_transaction.present?
      user = User.find(interim_transaction.user_id)
      Trial.create(name: 'rec_withdrawal test', test_field1: interim_transaction.action_id.to_s,
                   test_field2: user.id.to_s)
      transactions_open = user.transactions.where(status: 'approved')
      if transactions_open.sum(:cashback_sum) == data['amount'].to_f
        transactions_open.each do |trans|
          trans.status = 'paid'
          Trial.create(name: 'error_payment', test_field1: data['order_id']) unless trans.save
        end
      end
    else Trial.create(name: 'error_payment', test_field1: data['order_id'])
    end
  end

  private

  def correct_admitad_token?
    @action_data['status_code'] != 401
  end
end
