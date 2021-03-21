class LineApi
  REQUESTER = JsonRequester.new('https://api.line.me')

  class << self
    def get_profile(user_id)
      path = "/v2/bot/profile/" + user_id
      headers = { 'Authorization' => "Bearer #{Rails.application.credentials[Rails.env.to_sym][:line][:channel_token]}" }
      resp = REQUESTER.http_send(:get, path, {}, headers)
      raise "Fetch profile fail: #{resp['message']}" unless resp['status'] == 200
      resp
    end    
  end
end