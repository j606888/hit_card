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

    def clock_in(cookie)
      params = {
        em_step: 'ajax',
        encodeURIComponent: '1',
        locale: 'TW',
        buttonid: 'hrCottonCandyApp.workcardAir.addWorkCard',
        buttonlink: 'ajax_call',
        table_data: {'latitude' => 22.998839999999998,'longitude' =>120.2339853},
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
  end
end