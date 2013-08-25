class Preferences
  def self.day_boundary
    NSUserDefaults.standardUserDefaults['start_of_day']
  end
end