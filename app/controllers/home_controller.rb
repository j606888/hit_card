class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index
  skip_before_action :verify_authenticity_token

  def index

  end

  def webhook
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    puts "Signature: #{signature}"
    unless client.validate_signature(body, signature)
      return render json: { status: 400 }
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event.type
      when Line::Bot::Event::MessageType::Text
        result = LineBot.call(event.as_json['src'], client)
        # puts(result.error) unless result.success?
      end
    end

    render json: { status: 200 }
  end

  private
  def client
    @client ||= Line::Bot::Client.new { |config| 
      config.channel_id = Rails.application.credentials[Rails.env.to_sym][:line][:channel_id]
      config.channel_secret = Rails.application.credentials[Rails.env.to_sym][:line][:channel_secret]
      config.channel_token = Rails.application.credentials[Rails.env.to_sym][:line][:channel_token]
    }
  end


end