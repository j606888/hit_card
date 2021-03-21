class HrSystem
  PATH = "https://chr.ecmaker.com/servlet/jform"

  class << self
    def sign_in(account, password)
      params = {
        uid: account,
        pwd: password,
        button: '提交',
        locale: 'US',
        file: 'hrm8airw.pkg;hrm_98592865327356822677.cfg,hrm8w.pkg,briefcase.pkg'
      }

      resp = Faraday.post(PATH) do |req|
          req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
          req.body = URI.encode_www_form(params)
      end

      raise "Sign in failed: #{resp.body}" unless resp.status == 200
      raise "Password invalid: #{resp.body}" if resp.headers['set-cookie'].nil?
      resp.headers['set-cookie']
    end

    def clock_in(cookie, location)
      params = {
        em_step: 'ajax',
        encodeURIComponent: '1',
        locale: 'TW',
        buttonid: 'hrCottonCandyApp.workcardAir.addWorkCard',
        buttonlink: 'ajax_call',
        table_data: {'latitude' => location[:x],'longitude' =>location[:y] },
        em_POSITION: '1',
        file: 'hrm8airw.pkg;hrm_98592865327356822677.cfg,hrm8w.pkg,briefcase.pkg'
      }

      body = URI.encode_www_form(params).gsub('%3D%3E', '%3A')
      resp = Faraday.post(PATH, body) do |req|
        req["Content-Type"] = "application/x-www-form-urlencoded"
        req["Cookie"] = cookie.gsub(";,", ";")
      end

      resp.body
    end

    def error_info(cookie)
      params = {
        file: 'hrm8airw.pkg;hrm_98592865327356822677.cfg,hrm8w.pkg,briefcase.pkg',
        locale: 'TW',
        init_func: '棉花糖首頁'
      }
      resp = Faraday.get(PATH, params) do |req|
        req["Cookie"] = cookie.gsub(";,", ";")
      end

      resp = resp.body.to_s.force_encoding('UTF-8')

      regex = /{\"overtimeError\":{.* data-overTime=/
      short = resp.match(regex)[0]
      short.gsub!("' data-overTime=", '')
      data = JSON.parse(short)
      result = data['attendError'].map do |date, value|
        next if date == 'count'
        {
          date: date,
          card_in: value['in'],
          card_out: value['out'],
          message: value['error']
        }
      end

      result.compact
    end

    def clock_time(cookie)
      params = {
        file: 'hrm8airw.pkg;hrm_98592865327356822677.cfg,hrm8w.pkg,briefcase.pkg',
        locale: 'TW',
        init_func: '棉花糖首頁'
      }
      resp = Faraday.get(PATH, params) do |req|
        req["Cookie"] = cookie.gsub(";,", ";")
      end

      resp = resp.body.to_s.force_encoding('UTF-8')

      regex = /{\"other_card_record\":.*?}/
      result = resp.match(regex)[0]
      hash = JSON.parse(result)

      {
        card_in: hash['in_card'],
        card_out: hash['out_card'],
        all_cards: hash['other_card_record']
      }
    end

    def clock_in_list(cookie)
      params = {
        locale: 'TW',
        FUNCTION_NAME: 'B4.6.線上簽到退一覽表',
        buttonid: 'QUERY_CARDON',
        buttonlink: 'Ajax(No refresh Browser',
        file: 'hrm8airw.pkg;hrm_98592865327356822677.cfg,hrm8w.pkg,briefcase.pkg',
        qCPNTID: '凱鈿',
        qEMPID: '1070055 李彥增',
        dSDATE: '2021/03/21',
        dEDATE: '2021/03/31',
        table_data: '|#|CARDON;-1_-1_|#|col_0|,|col_1|,|col_2|,|col_3|,|col_4|,|col_5|,|col_6|,|col_7|,|col_8|,|col_9|,||~| RR20|,|雲端服務開發部|,|1070055|,|李彥增|,|20210321|,|021614|,|3.0.230.226|,|22.998839999999998,120.2339853|,||,| |,||~| RR20|,|雲端服務開發部|,|1070055|,|李彥增|,|20210321|,|101012|,|3.0.230.226|,|22.998839999999998,120.2339853|,||,| |,||#||#|[Parameters]|#|&id_extjs_CARDON_menu=&qSDATE=20210321&qEDATE=20210331&qCPNYID=kdan&qDEPT_NO=&qEMPID=1070055&cmc_window_1616292651705=|#|end'
      }

      body = URI.encode_www_form(params).gsub('%3D%3E', '%3A')
      resp = Faraday.post(PATH, body) do |req|
        req["Content-Type"] = "application/x-www-form-urlencoded"
        req["Cookie"] = cookie.gsub(";,", ";")
      end
    end
  end
end