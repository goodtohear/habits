class Habit < NSObject
  COLORS = [
      '#77A247', #GREEN
      '#488FB4', #BLUE
      '#E2804F', #ORANGE
      '#E7BE2B', #YELLOW
      '#E2804F', #PEACH
      '#875495', #PURPLE
      '#7A5D35' #BROWN
    ]
  # :first_in_chain, :last_in_chain, :mid_chain, :missed, :future, :before_start
  attr_accessor :title, :color
  
  def initialize(options={title: "New Habit", days_checked: []})
    @title = options[:title]
    @color = COLORS[0].to_color
    @days_checked = options[:days_checked]
    @created_at = options[:created_at] or Time.now
  end
  
  
  def self.all
    @all ||= (0..2).map do |item, index|
      Habit.new :title => "New Habit",
                :days_checked => days_ago(0..7) + days_ago(12..14),
                :created_at => Time.now - 14.days 
                # ,
                #                 :color => COLORS[index].to_color
    end
  end
  
  def self.delete habit
    all.delete habit
    App.notification_center.post :deleted_habit
  end
  
  def self.days_ago(days)
    days.map{ |days_ago| Time.now - days_ago.days  }
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
  def cellStateForDate date
    NSLog "cell state for date #{date}, habit: #{self}"
    return :before_start unless date
    return :future if date > Time.now
    return :before_start if date <= @created_at
    # return :first_in_chain 
    # return :last_in_chain
    day = Time.local(date.year,date.month,date.day)
    for checked_day in @days_checked
      return :mid_chain if checked_day >= day and (day + 1.day) > checked_day
    end
    return :missed
  end
end