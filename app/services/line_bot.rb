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
        result = @line_user.clock_in
        if result
          reply_message("打卡成功！")
        else
          reply_message("打卡失敗...")
        end
      when '紀錄'
        reply_message(@line_user.clock_time)
      when '異常'
        reply_message(@line_user.error_info)
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