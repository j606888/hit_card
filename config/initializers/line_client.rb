$line_client = Line::Bot::Client.new{ |config|
  config.channel_id = Rails.application.credentials[Rails.env.to_sym][:line][:channel_id]
  config.channel_secret = Rails.application.credentials[Rails.env.to_sym][:line][:channel_secret]
  config.channel_token = Rails.application.credentials[Rails.env.to_sym][:line][:channel_token]
}