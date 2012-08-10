class TimeHelper
  def self.hours
  	["Midnight"] + (1..11).map{|h|"#{h}am"} + ["Noon"] + (1..11).map{|h|"#{h}pm"}
  end
end