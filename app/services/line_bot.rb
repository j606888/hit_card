class LineBot < ServiceCaller
  def initialize(src)
    @src = src
    @reply_token = src['replyToken']
    @source = src['source']
    @message = src['message']['text'].downcase.strip
  end

  def call
    @line_user = LineUser.fetch_by_line_id(@source['userId'])

    case @line_user.mode
    when 'none_login'
      if @message == '登入'
        @line_user.account_mode!
        reply_message('請輸入員工編號')
      else
        reply_message("尚未登入，請輸入'登入'以繼續操作")
      end
    when 'account_mode'
      @line_user.update(account: @message)
      @line_user.password_mode!
      reply_message('請輸入密碼(身分證字號)')
    when 'password_mode'
      @line_user.update(password: @message.upcase)
      @line_user.try_to_fetch_cookie
      if @line_user.login?
        reply_message("登入成功！")
      else
        reply_message("登入失敗，請重新操作！")
      end
    when 'login'
      case @message
      when '打卡'
        location = @line_user.clock_in
        if location
          message = FlexMessage.hit_success(@line_user.name, @line_user.account, location, Time.now.in_time_zone('Taipei').strftime("%H:%M"))
          $line_client.reply_message(@reply_token, message)
        else
          reply_message("打卡失敗...")
        end
      when '紀錄'
        record = @line_user.clock_time
        message = FlexMessage.record(@line_user.name, @line_user.account, record[:card_in], record[:card_out], record[:all_cards])
        resp = $line_client.reply_message(@reply_token, message)
      when '異常'
        message = FlexMessage.error_info(@line_user.name, @line_user.account, @line_user.error_info)
        resp = $line_client.reply_message(@reply_token, message)
      end
    end
  end

  def reply_message(text)
    body = {
      type: 'text',
      text: text
    }
    $line_client.reply_message(@reply_token, body)
  end
end