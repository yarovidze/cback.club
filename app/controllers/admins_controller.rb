# frozen_string_literal: true

class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'liqpay'
  require 'http'
  require 'uri'
  require 'net/http'
  require 'json'

  def index; end

  # admitad

  def create_json(request)
    raw_json = JSON.generate(request)
    raw_json = JSON.parse raw_json.gsub('=>', ':')
    JSON(raw_json)
  end

  def autorisation_admitad
    code = params[:code] unless params[:code].nil?
    # request params
    p Rails.application.credentials.facebook[:APP_ID],
      Rails.application.credentials.facebook[:APP_SECRET],
      Rails.application.credentials.google[:APP_ID],
      Rails.application.credentials.google[:APP_SECRET],
      "------------------------------------------"
    state = '7c232ff20e64432fbe071228c0779f'
    redirect_uri = request.base_url + request.path
    response_type = 'code'
    grant_type = 'authorization_code'
    client_id = Rails.application.credentials.admidat[:client_id]
    client_secret = Rails.application.credentials.admidat[:client_secret]

    url = URI("https://api.admitad.com/token/?state=#{state}&redirect_uri=#{redirect_uri}&response_type=#{response_type}&client_id=#{client_id}&client_secret=#{client_secret}&code=#{code}&grant_type=#{grant_type}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Authorization'] = "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}"
    request['Cookie'] = 'gdpr_country=0'

    request = create_json(https.request(request).read_body)
    @response = request
    cookies[:refresh_token] = request['refresh_token'] unless request['refresh_token'].nil?
    cookies[:access_token] = request['access_token'] unless request['refresh_token'].nil?
    render :index
  end

  def get_action_data
    date = Date.strptime(params[:start_data], '%Y-%m-%d').strftime('%d.%m.%Y')
    limit = '222'
    order_by = 'date'
    action_type = 1

    url = URI("https://api.admitad.com/statistics/actions/?date_start=#{date}&limit=#{limit}&order_by=#{order_by}&action_type=#{action_type}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{params[:token]}"
    request['Cookie'] = 'gdpr_country=0; user_default_language=en'

    request = create_json(https.request(request).read_body.force_encoding('utf-8'))
    @action_data = request['results']
    if correct_admitad_token? && @action_data.present?
      rec_user_actions(@action_data)
    else
      scope = 'statistics advcampaigns banners websites'
      state = '7c232ff20e64432fbe071228c0779f'
      redirect_uri = 'https://cback.club/autorisation_admitad'
      response_type = 'code'
      client_id = Rails.application.credentials.admidat[:client_id]
      redirect_to "https://www.admitad.com/api/authorize/?scope=#{scope}&state=#{state}&redirect_uri=#{redirect_uri}&response_type=#{response_type}&client_id=#{client_id}"
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
    request['status_code'] != 401
  end
end
