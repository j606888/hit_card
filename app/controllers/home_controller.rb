class HomeController < ApplicationController
  before_action :authenticate_user!, only: :index
  skip_before_action :verify_authenticity_token

  def index

  end

  def webhook
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless $line_client.validate_signature(body, signature)
      return render json: { status: 400 }
    end

    events = $line_client.parse_events_from(body)
    events.each do |event|
      case event.type
      when Line::Bot::Event::MessageType::Text
        result = LineBot.call(event.as_json['src'])
        # puts(result.error) unless result.success?
      end
    end

    render json: { status: 200 }
  end
end