module TimeZone
  def self.set_time_zone
    Time.zone = User.current ? User.current.time_zone : (Account.current ? Account.current.time_zone : Time.zone)
  end

  def self.find_time_zone
    User.current ? User.current.time_zone : (Account.current ? Account.current.time_zone : Time.zone)
  end
end
