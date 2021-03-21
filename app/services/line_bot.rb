class LineBot < ServiceCaller
  def initialize(src, client)
    @src = src
    @reply_token = src['replyToken']
    @source = src['source']
    @message = src['message']['text'].downcase.strip
    @client = client
  end

  def call
    @line_user = LineUser.fetch_by_line_id(@source['userId'])

    case @line_user.mode
    when 'none_login'
      if @message == 'login'
        @line_user.account_mode!
        reply_message('Please enter your account')
      else
        reply_message("You haven't login yet. Please enter 'login' to process.")
      end
    when 'account_mode'
      @line_user.update(account: @message)
      @line_user.password_mode!
      reply_message('Please enter your password')
    when 'password_mode'
      @line_user.update(password: @message.upcase)
      @line_user.try_to_fetch_cookie
      if @line_user.login?
        reply_message("Congratulations, you login success!\nNow you can enter '打卡' to clock in.")
      else
        reply_message("Sorry, login failed. Please enter 'login' and try again.")
      end
    when 'login'
      # binding.pry
      case @message
      when '打卡'
        result = @line_user.clock_in
        if result
          reply_message("Clock in Success!")
        else
          reply_message("Oops, clock in Failed...")
        end
      when '查看'
        reply_message(@line_user.clock_time)
      when '異常'
        reply_message(@line_user.error_info)
      else
        reply_message("Enter '打卡' to clock in\nEnter '查看' to check todays record\nEnter '異常' to check error time")
      end
    end
  end

  def reply_message(text)
    body = {
      type: 'text',
      text: text
    }
    rep = @client.reply_message(@reply_token, body)
  end
end