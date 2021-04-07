# frozen_string_literal: true

# Rails cache
# Singeltone
require 'http'
require 'uri'
require 'net/http'
require 'json'

Admitad.config do |c|
  c.client_id     = '9Oo9LsDIaQhqCUtVkbSFIPfSmXQ7mQ'
  c.client_secret = '0cD5yQEVDAA8hK4NSqDVJF7VUHHU5A'
  c.scope         = ''
end

def create_json(request)
  raw_json = JSON.generate(request)
  raw_json = JSON.parse raw_json.gsub('=>', ':')
  JSON(raw_json)
end

def autorisation_admitad
  cookies[:code] = params[:code] unless params[:code].nil?
  url = URI("https://api.admitad.com/token/?state=7c232ff20e64432fbe071228c0779f&redirect_uri=https%3A%2F%2Fcback.club&response_type=code&client_id=9Oo9LsDIaQhqCUtVkbSFIPfSmXQ7mQ&client_secret=0cD5yQEVDAA8hK4NSqDVJF7VUHHU5A&code=#{cookies[:code]}&grant_type=authorization_code")
  # url = URI("https://api.admitad.com/token/?state=7c232ff20e64432fbe071228c0779f&redirect_uri=http%3A%2F%2F127.0.0.1:3000%2F&response_type=code&client_id=9Oo9LsDIaQhqCUtVkbSFIPfSmXQ7mQ&client_secret=0cD5yQEVDAA8hK4NSqDVJF7VUHHU5A&code=#{cookies[:code]}&grant_type=authorization_code")

  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  request = Net::HTTP::Post.new(url)
  request['Authorization'] =
    'Basic OU9vOUxzRElhUWhxQ1V0VmtiU0ZJUGZTbVhRN21ROjBjRDV5UUVWREFBOGhLNE5TcURWSkY3VlVISFU1QQ=='
  request['Cookie'] = 'gdpr_country=0'

  request = create_json(https.request(request).read_body)
  @response = request
  cookies[:refresh_token] = request['refresh_token'] unless request['refresh_token'].nil?
  cookies[:access_token] = request['access_token'] unless request['refresh_token'].nil?
end

def get_subid_data
  url = URI('https://api.admitad.com/statistics/sub_ids/?date_start=01.01.2021&order_by=sub_id')

  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request['Authorization'] = "Bearer #{cookies[:access_token]}"
  request['Cookie'] = 'gdpr_country=0; user_default_language=en'
  request = create_json(https.request(request).read_body)

  @subid_data = request
  cookies[:subid_data] = request['results'] unless request['status_code'] == 401
end

def get_action_data
  url = URI('https://api.admitad.com/statistics/actions/?date_start=14.03.2021&limit=222&order_by=date&action_type=1')

  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request['Authorization'] = "Bearer #{cookies[:access_token]}"
  request['Cookie'] = 'gdpr_country=0; user_default_language=en'

  request = create_json(https.request(request).read_body.force_encoding('utf-8'))
  @action_data = request['results']
  cookies[:action_data] = request['results'] unless request['status_code'] == 401
end

def rec_user_actions
  action = cookies[:action_data]
  action.each do |client|
    next if client['subid'] == ''

    begin
      puts client['subid']
      client['subid'] = '1' if client['subid'] == '4'
      puts client['subid']
      @client = User.find(client['subid'].to_i) if User.find(client['subid'].to_i).present?
      transaction_params = params.permit(:offer_id, :status, :total, :cashback_sum).merge(
        user_id: client['subid'], action_id: client['id']
      )
      @transaction = Transaction.find_by(transaction_params.except(:status, :total))
      @offer = Offer.find_by(name: client['advcampaign_name'])
      unless @transaction.present?
        @transaction = Transaction.create(transaction_params.merge(total: client['payment_sum_open']))
        @transaction.action_id = client['id']
      end
      @transaction.total = client['cart']
      @transaction.status = client['status']
      @transaction.offer_id = @offer.id
      @transaction.cashback_sum = client['payment']
      @transaction.save
    rescue ActiveRecord::RecordNotFound
      next
    end
  end
end

def rec_user_data
  action = cookies[:subid_data]
  action.each do |client|
    next if client['subid'] == ''

    begin
      @client = User.find(client['subid']) if User.find(client['subid']).present?
      transaction_params = params.permit(:total).merge(user_id: client['subid'], offer_id: 1, status: 0)
      @transaction = Transaction.find_by(transaction_params.except(:status, :total))
      if @transaction.present?
        @transaction.total = client['payment_sum_open']
        @transaction.status = 0
        @transaction.save
      else
        Transaction.create(transaction_params.merge(total: client['payment_sum_open']))
      end
    rescue ActiveRecord::RecordNotFound
      next
    end
  end
end
