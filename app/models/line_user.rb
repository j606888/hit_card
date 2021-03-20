class LineUser < ApplicationRecord
  enum plan: { free: 0, premium: 1, enterprise: 2 }
  enum mode: { none_login: 0, account_mode: 1, password_mode: 2, login: 3 }

  def self.fetch_by_line_id(line_id)
    line_user = self.find_or_initialize_by(line_id: line_id)
    return line_user unless line_user.new_record?

    profile = LineApi.get_profile(line_id)
    line_user.name = profile['displayName']
    line_user.save

    line_user
  end

  def try_to_fetch_cookie
    cookie = HrSystem.sign_in(account, password)
    self.update(cookie: cookie)
    self.login!
  rescue Exception
    self.update(account: nil, password: nil)
    self.none_login!
  end

  def clock_in
    resp = HrSystem.clock_in(self.cookie)
    true
  rescue Exception
    false
  end
end
