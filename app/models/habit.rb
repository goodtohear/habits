class Habit < NSObject
  attr_accessor :title
  def initialize(options={title: "New Habit", days_checked: []})
    @title = options[:title]
    @days_checked = options[:days_checked]
  end
  
  def self.all
    @all ||= (0..2).map do |item|
      Habit.new :title => "New Habit",
                :days_checked => days_ago(0..8) + days_ago(10..14)
    end
  end
  
  def self.delete habit
    all.delete habit
    App.notification_center.post :deleted_habit
  end
  
  def self.days_ago(days)
    days.map{ |days_ago| Time.now - days_ago  }
  end
  
  def currentChainLength
    count = 0
    last_day = Time.now
    for checked_day in @days_checked
      return count if last_day - checked_day > 1 
      count += 1
    end
    0
  end
  
  def totalDays
    @days_checked.count
  end
  def longestChain
    30
  end
  def blank?
    @days_checked.count == 0
  end
end