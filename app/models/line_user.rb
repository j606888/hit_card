class LineUser < ApplicationRecord
  enum plan: { free: 0, premium: 1, enterprise: 2 }
  enum mode: { none_login: 0, account_mode: 1, password_mode: 2, login: 3 }

  LOCARION_RANGE = {
    x_min: 22.9987352,
    x_max: 22.9990040,
    y_min: 120.2335215,
    y_max: 120.2346388
  }

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
    RichMenu.find_by(name: 'after_login').link_user_rich_menu(self.line_id)
  rescue Exception
    self.update(account: nil, password: nil)
    self.none_login!
  end

  def clock_in
    location = random_location
    resp = HrSystem.clock_in(self.cookie, location)
    "#{location[:x]}, #{location[:y]}"
  rescue Exception
    false
  end

  def clock_time
    HrSystem.clock_time(self.cookie)
  end

  def error_info
    HrSystem.error_info(self.cookie)
  end

  def random_location
    x = LOCARION_RANGE[:x_min] + (LOCARION_RANGE[:x_max] - LOCARION_RANGE[:x_min]) * rand()
    y = LOCARION_RANGE[:y_min] + (LOCARION_RANGE[:y_max] - LOCARION_RANGE[:y_min]) * rand()
    {
      x: x.round(7),
      y: y.round(7)
    }
  end
end
