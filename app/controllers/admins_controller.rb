# frozen_string_literal: true

class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'liqpay'

  def index; end

  def autorisation_admitad
    @admitad = AdmitadService.new
    if !params[:code].nil?
      @response = @admitad.get_admitad_access_token(request.base_url + request.path, params[:code])
      cookies[:refresh_token] = @response['refresh_token'] unless @response['refresh_token'].nil?
      cookies[:access_token] = @response['access_token'] unless @response['refresh_token'].nil?
    else redirect_to @admitad.get_admitad_code
    end
    render :index
  end

  def get_action_data
    @admitad = AdmitadService.new
    @action_data = @admitad.get_admitad_action_data(params[:start_data], params[:token])
    if correct_admitad_token? && @action_data.present?
      rec_user_actions(@action_data['results'])
    else
      redirect_to @admitad.get_admitad_code
    end
  end

  def rec_user_actions(action)
    # if status aproved count users for whitdrawl and all sum
    @users_count = action.count
    @all_sum = 0
    @ready_to_withdrawal = 0
    action.each do |client|
      next if client['subid'] == ''

      # on production absent user with id 4
      client['subid'] = '1' if client['subid'] == '4'
      @client = User.find_by(id: client['subid'].to_i)
      next if @client.nil?

      transaction_params = params.permit(:offer_id, :status, :total, :cashback_sum).merge(user_id: @client.id,
                                                                                          action_id: client['id'])

      @transaction = Transaction.find_by(transaction_params.except(:status, :total))
      @offer = Offer.find_by(name: client['advcampaign_name'])
      Trial.create(name: 'test_admitad_methods',
                   test_field1: @client.id,
                   test_field2: @transaction.id,
                   test_field3: @offer.id).save
      unless @transaction.present?
        @transaction = Transaction.create(transaction_params.merge(total: client['payment_sum_open']))
        @transaction.action_id = client['id']
      end
      next if @transaction.status == 4

      @transaction.total = client['cart']
      @transaction.status = client['status']
      @ready_to_withdrawal += 1 if client['status'] == 'approved'
      @transaction.offer_id = @offer.id
      @transaction.cashback_sum = client['payment']
      @all_sum += client['payment']
      @transaction.save
      Trial.create(name: 'test_admitad_methods2',
                   test_field1: @users_count,
                   test_field2: @all_sum,
                   test_field3: @ready_to_withdrawal).save
    end
    render 'admins/_rec_actions_result'
  end

  # liqpay
  def withdrawal_get
    data = params[:data]
    signature = params[:signature]
    liqpay = Liqpay.new
    if liqpay.match?(data, signature)
      Trial.create(name: 'liqpay_sing_correct?', test_field1: liqpay.match?(data, signature),
                   test_field2: liqpay.decode_data(data)).save
      rec_withdrawal(liqpay.decode_data(data))
    end
  end

  def rec_withdrawal(data)
    interim_transaction = Transaction.find_by(action_id: data['order_id'].to_i)
    user = User.find(interim_transaction.user_id)
    Trial.create(name: 'rec_withdrawal test', test_field1: interim_transaction.action_id.to_s,
                 test_field2: user.id.to_s).save
    transactions_open = user.transactions.where(status: 1)
    if transactions_open.sum(:cashback_sum) == data['amount'].to_f
      transactions_open.each do |trans|
        trans.status = 4
        trans.save
      end
    end
  end

  private

  def correct_admitad_token?
    @action_data['status_code'] != 401
  end
end
