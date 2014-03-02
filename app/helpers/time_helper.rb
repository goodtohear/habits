# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class TimeHelper
  FIRST_OPTION_OFFSET = 6 # must be >= 0

  def self.dateline_offset
    FIRST_OPTION_OFFSET
  end

  def self.hours
    @hours ||= (["Midnight"] + (1..11).map{|h|"#{h}am"} + ["Noon"] + (1..11).map{|h|"#{h}pm"})
  end
  def self.rotatedHours
  	@rotatedHours ||= hours.rotate(FIRST_OPTION_OFFSET)
  end
  def self.time hour, minute
    components = NSDateComponents.new 
    components.year = 2012 # arbitrary
    components.hour = hour.to_i
    components.minute = minute.to_i
    NSLog "Creating date from components #{components}"
    NSCalendar.currentCalendar.dateFromComponents components
  end
  
  def self.formattedTime hour, minute
    time = self.time hour, minute
    formatter = NSDateFormatter.new
    formatter.dateStyle = NSDateFormatterNoStyle
    formatter.timeStyle = NSDateFormatterShortStyle
    formatter.stringFromDate time
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
