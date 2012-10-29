class TimeHelper
  FIRST_OPTION_OFFSET = 6 # must be >= 0

  def self.dateline_offset
    FIRST_OPTION_OFFSET
  end

  def self.hours
    @hours ||= (["Midnight"] + (1..11).map{|h|"#{h}am"} + ["Noon"] + (1..11).map{|h|"#{h}pm"} + ["Midnight"])
  end
  def self.rotatedHours
  	@rotatedHours ||= hours.rotate(FIRST_OPTION_OFFSET)
  end
  
  def self.indexOfHour hour
  	return 0 if hour.nil?
  	hour -= FIRST_OPTION_OFFSET 
  	hour += 24 if hour < 0
  	hour
  end

  def self.hourForIndex index
  	index += FIRST_OPTION_OFFSET
  	index -= 24 if index > 23 
  	index
  end
  
  def self.addDays days, toDate: date
    @dayComponents ||= NSDateComponents.alloc.init
    @dayComponents.day = days
    NSCalendar.currentCalendar.dateByAddingComponents @dayComponents, toDate: date, options: 0
  end
  
  def self.daysBetweenDate first, andDate: last
    NSCalendar.currentCalendar.components NSDayCalendarUnit, fromDate: first, toDate: last, options: 0
  end
  
end