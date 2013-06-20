# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class Habit < NSObject
  COLORS = [
      '#77A247', #GREEN
      '#875495', #PURPLE
      '#E2804F', #ORANGE
      '#E7BE2B', #YELLOW
      '#D28895', #PINK
      '#488FB4', #BLUE
      '#7A5D35' #BROWN
    ]
  # :first_in_chain, :last_in_chain, :mid_chain, :missed, :future, :before_start
  attr_accessor :title, :color_index, :created_at, :days_checked, :time_to_do, :active, :order, :days_required
  attr_reader :notification
  def serialize
    {
      title: @title,
      color_index: @color_index,
      created_at: @created_at,
      days_checked: @days_checked,
      time_to_do: @time_to_do || "",
      active: @active || false,
      order: @order,
      days_required: @days_required
    }
  end  
  
  def self.nextOrder
    @@order ||= 0
    @@order += 1
    @@order
  end
  
  def initialize(options={title: "New Habit", active: true, days_checked: {}})
    @title = options[:title]
    @active = options[:active] || false
    @color_index =  options[:color_index] || Habit.next_unused_color_index

    # migrate to new format if needed
    if(options[:days_checked].class == Array)
      NSLog "MIGRATING #{options[:days_checked]}"
      @days_checked = migrate_array_to_hash options[:days_checked]
    else
      @days_checked = options[:days_checked] || {}
    end  

    @created_at = options[:created_at] || Time.now
    @time_to_do = options[:time_to_do]
    @interval = 1 # day
    @days_required = options[:days_required] || Calendar::DAYS.map{|d| true }
    @order = options[:order] || Habit.nextOrder
  end

  def migrate_array_to_hash days_checked_array
    result = {}
    for item in days_checked_array
      key = item.to_s[0..9]
      result[key] = true
    end
    return result
  end
  
  def is_new?
    @title == "New Habit"
  end
  
  def color
    COLORS[@color_index].to_color
  end
  def no_reminders?
    time_to_do.nil? or time_to_do == ""
  end
  def self.save!
    recalculate_all_notifications
    @queue ||= Dispatch::Queue.concurrent('goodtohear.habits.save')
    @queue.async do
      data = all.map(&:serialize)
      # NSLog "saving data #{data}"
      App::Persistence['habits'] = data

    end
  end
  
  def self.load
    data = App::Persistence['habits']
    return nil unless data
    result = data.map do |item|
      Habit.new item
    end
  end
   
  def self.all
    @all ||= load || []
  end
  
  def self.active
    (all.select { |h| h.active }).sort { |a, b| b.order <=> a.order }
  end
  
  def self.inactive
    (all.select { |h| !h.active }).sort { |a, b| b.order <=> a.order }
  end
  
  def compare other
    self.order.compare other.order
  end
  
  def self.next_unused_color_index
    return 0 unless @all
    occurences = @all.map(&:color_index) + (0..COLORS.count-1).to_a
    counts = occurences.group_by {|n| n }.map{|key,items| {key => items.count}}
    low_count = counts.map{|c| c.values.first}.min
    counts.find{|c| c.values.first == low_count }.keys.first.to_i
  end
  
  def self.delete habit
    all.delete habit
    save!
    App.notification_center.post :deleted_habit
  end
  
  def self.days_ago(days)
    days.map{ |days_ago| Time.now - days_ago.days  }
  end
  def longestChain
    return 0
    # NSLog "calculating chain #{title}"
    result = 0
    count = 0
    last_day = Time.now
    last_day = Time.local last_day.year, last_day.month, last_day.day
    for checked_day in @days_checked.reverse
      comparison = TimeHelper.daysBetweenDate checked_day, andDate: last_day
      if comparison.day > @interval
        # NSLog "compare(#{compare}) was more than interval (@interval), count = #{count}, result = #{result}"
        result = [count, result].max
        count = 0
      end
      count += 1
      last_day = checked_day
    end
    [result, count].max
  end
  
  def currentChainLength
    count = 0
    now = Time.now
    last_day = Time.local now.year, now.month, now.day
    
    while last_day > earliest_date
      if includesDate last_day
        count += 1
      end
      if !continuesActivityBefore(last_day)
        return count
      end

      last_day = TimeHelper.addDays -1, toDate: last_day
    end
    count
  end
  
  def check_days days
    for day in days
      key = key(day)
      @days_checked[key] = true
    end
    clearDaysCache()
  end
  
  def uncheck_days days
    for day in days
      key = key(day)
      @days_checked.delete key
    end
    clearDaysCache()
  end
  def earliest_date
    return @earliest_date if @earliest_date
    return Time.now if @days_checked.count == 0

    @earliest_date = NSDate.dateWithNaturalLanguageString @days_checked.keys.sort.first
  end
  def clearDaysCache
    @earliest_date = nil
  end
  
  def totalDays
    @days_checked.count
  end
  def blank?
    @days_checked.count == 0
  end
  
  def self.recalculate_all_notifications
    active.each(&:recalculate_notification)
  end
  def recalculate_notification
    @notification = nil
    calculate_notification()
  end

  def timeWithHour hour, daysTime: dayOffset
    day = TimeHelper.addDays dayOffset, toDate: Time.now
    Time.local day.year, day.month, day.day, hour, 0
  end

  TOMORROW = 1
  TODAY = 0

  def alarm dayOffset, atHour: hour, text: text
    @notification = UILocalNotification.alloc.init
    # @notification.timeZone = NSTimeZone.defaultTimeZone
    @notification.fireDate = timeWithHour hour, daysTime: dayOffset
    @notification.alertBody = text
    # @notification.applicationIconBadgeNumber = 1
    # @notification.repeatCalendar = NSCalendar.currentCalendar
    @notification.repeatInterval = NSDayCalendarUnit
    
    # Debugger.buffer << "Scheduled #{title} initial at #{time_to_do} for time #{@notification.fireDate}"
    
    # NSLog "alarm:#{text} #{notification.fireDate}"
  end

  def calculate_notification now=Time.now
    return if no_reminders?
    # schedule for tomorrow if already passed reminder for today
    day = (due?(now) or done?(now)) ? TOMORROW : TODAY
    
    alarm day, atHour: time_to_do, text: title
  end
  
  def toggle(time)
    key = key(time)
    if @days_checked[key]
      @days_checked.delete key
    else
      @days_checked[key] = true
    end
    clearDaysCache()
    Habit.save!
  end
  def includesDate date
    @days_checked[key(date)] # || !days_required[date.wday]
  end
  def continuesActivityBefore date
    # iterate back up to 6 days 
    (1..7).each do |n|
      possible_date = TimeHelper.addDays -n, toDate: date
      return true if self.includesDate possible_date
      return false if days_required[possible_date.wday]
    end
    false
  end
  def continuesActivityAfter date
    # iterate forward up to 6 days 
    (1..7).each do |n|
      possible_date = TimeHelper.addDays n, toDate: date
      return true if self.includesDate possible_date
      return false if days_required[possible_date.wday]
    end
    false
  end
  def key(day)
    Time.local( day.year, day.month, day.day).to_s[0..9]
  end
  def day(time)
     Time.local time.year, time.month, time.day
  end

  def done?(time)
    @days_checked[key(time)]
  end

  def due?(time)
    return false unless @active
    return false if time_to_do.nil? or time_to_do == ''
    return time.hour >= time_to_do 
    
  end

end