# frozen_string_literal: true

# Methods for post/push data to admidat

class AdmitadService
  require 'http'
  require 'uri'
  require 'net/http'
  require 'json'

  def initialize
    @client_id = Rails.application.credentials.admidat[:client_id]
    @client_secret = Rails.application.credentials.admidat[:client_secret]
    @admidat_url = 'https://api.admitad.com/'
    @state = '7c232ff20e64432fbe071228c0779f'
  end

  def create_json(request)
    raw_json = JSON.generate(request)
    raw_json = JSON.parse raw_json.gsub('=>', ':')
    JSON(raw_json)
  end

  def get_admitad_access_token(redirect_uri, code)
    # request params
    response_type = 'code'
    grant_type = 'authorization_code'

    url = URI("#{@admidat_url}token/?state=#{@state}&redirect_uri=#{redirect_uri}" \
                                                   "&response_type=#{response_type}" \
                                                   "&client_id=#{@client_id}" \
                                                   "&client_secret=#{@client_secret}" \
                                                   "&code=#{code}" \
                                                   "&grant_type=#{grant_type}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request['Authorization'] = "Basic #{Base64.strict_encode64("#{@client_id}:#{@client_secret}")}"
    request['Cookie'] = 'gdpr_country=0'

    create_json(https.request(request).read_body)
  end

  def get_admitad_code
    scope = 'statistics advcampaigns banners websites'
    redirect_uri = 'https://cback.club/auth_admitad'
    response_type = 'code'
    "https://account.admitad.com/ru/api/authorize/?scope=#{scope}&state=#{@state}" \
                                                                "&redirect_uri=#{redirect_uri}" \
                                                                "&response_type=#{response_type}" \
                                                                "&client_id=#{@client_id}"
  end

  def get_admitad_action_data(start_date, token)
    date = Date.strptime(start_date, '%Y-%m-%d').strftime('%d.%m.%Y')
    limit = '222'
    order_by = 'date'
    action_type = 1

    url = URI("#{@admidat_url}statistics/actions/?date_start=#{date}&limit=#{limit}" \
                                                                   "&order_by=#{order_by}" \
                                                                   "&action_type=#{action_type}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{token}"
    request['Cookie'] = 'gdpr_country=0; user_default_language=en'

    create_json(https.request(request).read_body.force_encoding('utf-8'))
  end
end
