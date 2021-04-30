# frozen_string_literal: true

class AdminsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'liqpay'
  require 'http'
  require 'uri'
  require 'net/http'
  require 'json'

  def index; end

  # admidat

  def create_json(request)
    raw_json = JSON.generate(request)
    raw_json = JSON.parse raw_json.gsub('=>', ':')
    JSON(raw_json)
  end

  def autorisation_admitad
    cookies[:code] = params[:code] unless params[:code].nil?
    url = URI("https://api.admitad.com/token/?state=7c232ff20e64432fbe071228c0779f&redirect_uri=#{request.base_url + request.path}&response_type=code&client_id=9Oo9LsDIaQhqCUtVkbSFIPfSmXQ7mQ&client_secret=0cD5yQEVDAA8hK4NSqDVJF7VUHHU5A&code=#{cookies[:code]}&grant_type=authorization_code")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Authorization'] = 'Basic OU9vOUxzRElhUWhxQ1V0VmtiU0ZJUGZTbVhRN21ROjBjRDV5UUVWREFBOGhLNE5TcURWSkY3VlVISFU1QQ=='
    request['Cookie'] = 'gdpr_country=0'

    request = create_json(https.request(request).read_body)
    @response = request
    cookies[:refresh_token] = request['refresh_token'] unless request['refresh_token'].nil?
    cookies[:access_token] = request['access_token'] unless request['refresh_token'].nil?
    render :index
  end

  def get_action_data
    url = URI("https://api.admitad.com/statistics/actions/?date_start=#{Date.strptime(params[:start_data], '%Y-%m-%d').strftime("%d.%m.%Y")}&limit=222&order_by=date&action_type=1")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{cookies[:access_token]}"
    request['Cookie'] = 'gdpr_country=0; user_default_language=en'

    request = create_json(https.request(request).read_body.force_encoding('utf-8'))
    @action_data = request['results']
    if correct_admitad_token? and @action_data.present?
      cookies[:action_data] = request['results']
      Trial.create(name: 'action_data_result',
                   test_field1: @action_data).save
      rec_user_actions(@action_data)
      else redirect_to 'https://www.admitad.com/api/authorize/?scope=statistics advcampaigns banners websites&state=7c232ff20e64432fbe071228c0779f&redirect_uri=https://cback.club/autorisation_admitad&response_type=code&client_id=9Oo9LsDIaQhqCUtVkbSFIPfSmXQ7mQ'
      #else redirect_to 'https://www.admitad.com/api/authorize/?scope=statistics advcampaigns banners websites&state=7c232ff20e64432fbe071228c0779f&redirect_uri=http://127.0.0.1:3000//autorisation_admitad&response_type=code&client_id=9Oo9LsDIaQhqCUtVkbSFIPfSmXQ7mQ'
    end
  end

  def rec_user_actions(action)
    # if status aproved count users for whitdrawl and all sum
    @users_count = action.count
    @all_sum = 0
    @ready_to_withdrawal = 0
    action.each do |client|
      next if client['subid'] == ''

      begin
        # on production absent user with id 4
        client['subid'] = '28' if client['subid'] == '4'
        @client = User.find(client['subid'].to_i) if User.find(client['subid'].to_i).present?
        transaction_params = params.permit(:offer_id, :status, :total, :cashback_sum).merge(user_id: client['subid'], action_id: client['id']
        )
        @transaction = Transaction.find_by(transaction_params.except(:status, :total))
        @offer = Offer.find_by(name: client['advcampaign_name'])
        unless @transaction.present?
          @transaction = Transaction.create(transaction_params.merge(total: client['payment_sum_open']))
          @transaction.action_id = client['id']
        end
        unless @transaction.status == 4
          @transaction.total = client['cart']
          @transaction.status = client['status']
          @ready_to_withdrawal += 1 if client['status'] == "approved"
          @transaction.offer_id = @offer.id
          @transaction.cashback_sum = client['payment']
          @all_sum += client['payment']
          @transaction.save
        end
        Trial.create(name: 'test',
                     test_field1: 1).save
      rescue ActiveRecord::RecordNotFound
        next
      end
      puts @client, @transaction, "---------------------------------"
      Trial.create(name: 'action_each',
                   test_field1: @client,
                   test_field2: @transaction).save
    end
    Trial.create(name: 'action_result2',
                 test_field1: @users_count,
                 test_field2: @all_sum,
                 test_field3: @ready_to_withdrawal).save
    render 'admins/_rec_actions_result'
  end

  # liqpay
  def withdrawal_get
    data = params[:data]
    signature = params[:signature]
    liqpay = Liqpay.new
    if liqpay.match?(data, signature)
      Trial.create(name: 'liqpay_sing_correct?',
                   test_field1: liqpay.match?(data, signature),
                   test_field2: liqpay.decode_data(data)).save
      rec_withdrawal(liqpay.decode_data(data))
    end
  end

  def rec_withdrawal(data)
    interim_transaction = Transaction.find_by(action_id: data['order_id'].to_i)
    user = User.find(interim_transaction.user_id)
    Trial.create(name: 'rec_withdrawal test', test_field1: interim_transaction.action_id.to_s, test_field2: user.id.to_s).save
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
    (request['status_code'] == 401) ? false : true
  end

end
