class Admitad
  require 'uri'
  require 'net/http'
  require 'json'

  Admitad.config do |c|
    c.client_id     = ''
    c.client_secret = ''
    c.scope         = ''
  end

  def create_json(request)
    raw_json = JSON.generate(request)
    raw_json = JSON.parse raw_json.gsub('=>', ':')
    JSON(raw_json)
  end

  def autorisation_admitad
    cookies[:code] = params[:code] unless params[:code].nil?
    url = URI("https://api.admitad.com/token/?state=7c232ff20e64432fbe071228c0779f&redirect_uri=http%3A%2F%2F127.0.0.1:3000%2F&response_type=code&client_id=9Oo9LsDIaQhqCUtVkbSFIPfSmXQ7mQ&client_secret=0cD5yQEVDAA8hK4NSqDVJF7VUHHU5A&code=#{cookies[:code]}&grant_type=authorization_code")

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
    puts https.request(request).read_body
    request = create_json(https.request(request).read_body.force_encoding('utf-8'))
    @action_data = request['results']
  end



end