# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class Habit < NSObject
  COLORS = [
    Colors::GREEN,
    Colors::PURPLE,
    Colors::ORANGE,
    Colors::YELLOW,
    Colors::PINK,
    Colors::BLUE,
    Colors::BROWN
    ]
  # :first_in_chain, :last_in_chain, :mid_chain, :missed, :future, :before_start
  attr_accessor :title, :color_index, :created_at, :days_checked, :time_to_do,:minute_to_do, :active, :order, :days_required
  attr_reader :notifications
  def serialize
    {
      title: @title,
      color_index: @color_index,
      created_at: @created_at,
      days_checked: @days_checked,
      time_to_do: @time_to_do || "",
      minute_to_do: @minute_to_do || 0,
      active: @active || false,
      order: @order,
      days_required: @days_required,
      longest_chain: @longest_chain
    }
  end  
  @@count = 0
  def self.nextOrder
    @@count + 1 #self.all.count + 1
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
    @minute_to_do = options[:minute_to_do] || 0
    @interval = 1 # day
    @days_required = options[:days_required] || Calendar::DAYS.map{|d| true }
    @order = options[:order] || Habit.nextOrder
    @longest_chain = options[:longest_chain] || recalculate_longest_chain
    
    @@count += 1
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
    COLORS[@color_index]
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
  def self.active_today
    self.active.select{|h| h.days_required[Time.now.wday] }
  end
  def self.active_but_not_today
    self.active.select{|h| !h.days_required[Time.now.wday] }
  end
  def self.overdue
    (all.select {|h| !h.days_required[Time.now.wday] && h.currentChainLength == 0 })
  end
  def self.inactive
    (all.select { |h| !h.active }).sort { |a, b| b.order <=> a.order }
  end
  
  def <=> other
    self.order <=> other.order
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

  def targetChainLength
    return 28
  end
  def recalculate_longest_chain
    @longest_chain = calculateChainLengthFindLongest true
  end

  def longestChain
    @longest_chain
  end
  def calculateChainLengthFindLongest shouldFindLongest
    result = 0
    
    count = 0
    now = Time.now
    last_day = Time.local now.year, now.month, now.day
    # this is the same as currentChainLength only instead of returning a result, we reset the count when a missed day is found.
    while last_day >= earliest_date
      if includesDate last_day
        count += 1
      end
      if !continuesActivityBefore(last_day)
        # TODO: Make a negative count possible
        return count unless shouldFindLongest
        result = [result,count].max
        count = 0
      end

      last_day = TimeHelper.addDays -1, toDate: last_day
    end
    [result, count].max  
  end
  def currentChainLength
    calculateChainLengthFindLongest false
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

    date = NSDate.dateWithNaturalLanguageString @days_checked.keys.sort.first
    @earliest_date = Time.local date.year, date.month, date.day
  end
  def clearDaysCache
    @earliest_date = nil
    recalculate_longest_chain()
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
    @notifications = []
    calculate_notification()
  end

  TOMORROW = 1
  TODAY = 0

  def calculate_notification now=Time.now
    return if no_reminders?
    # schedule for tomorrow if already passed reminder for today
    dayOffset = (due?(now) or done?(now)) ? TOMORROW : TODAY
    for n in (0..6)
      day = TimeHelper.addDays dayOffset + n, toDate: now
      if days_required[day.wday]
        notification = UILocalNotification.alloc.init
        notification.fireDate = Time.local day.year, day.month, day.day, time_to_do, minute_to_do
        notification.alertBody = title
        notification.repeatInterval = NSWeekCalendarUnit
        @notifications << notification
      end
    end

  end
  def self.habitCountForDate date
    weekday = date.wday
    count = 0
    for habit in self.active
      count +=1 if habit.days_required[weekday]
    end
    count
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
    @days_checked[key(date)]
  end
  def continuesActivityFromDate date, overRange: range
    # iterate back up to 6 days 
    range.each do |n|
      possible_date = TimeHelper.addDays n, toDate: date
      return true if self.includesDate possible_date
      return false if days_required[possible_date.wday]
    end
    false  
  end

  def continuesActivityBefore date
    return continuesActivityFromDate date, overRange: (-7..-1).to_a.reverse
  end
  def continuesActivityAfter date
    return continuesActivityFromDate date, overRange: (1..7).to_a
  end
  def key(day)
    Time.local( day.year, day.month, day.day).to_s[0..9]
  end
  def day(time)
     Time.local time.year, time.month, time.day
  end
  def needs_to_be_done?(time)
    !done?(time) and days_required[time.wday]
  end
  def done?(time)
    @days_checked[key(time)]
  end

  def due?(time)
    return false unless @active
    return false unless days_required[time.wday]
    return false if time_to_do.nil? or time_to_do == ''
    return time.hour >= time_to_do 
    
  end

end
