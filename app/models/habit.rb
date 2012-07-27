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
  attr_accessor :title, :color_index, :created_at, :days_checked
  def serialize
    {
      title: @title,
      color_index: @color_index,
      created_at: @created_at,
      days_checked: @days_checked.map(&:to_s)
    }
  end  
  def initialize(options={title: "New Habit", days_checked: []})
    @title = options[:title]
    @color_index =  options[:color_index] || Habit.next_unused_color_index
    @days_checked = options[:days_checked] || []
    @created_at = options[:created_at] || Time.now
  end
  
  def color
    COLORS[@color_index].to_color
  end
  
  def self.save!
    App::Persistence['habits'] = all.map(&:serialize)
  end
  
  def self.load
    data = App::Persistence['habits']
    NSLog "data from persistence #{data}"
    return nil unless data
    data.map do |item|
      item[:days_checked] = item[:days_checked].map{|d| Time.local d}
      NSLog "item after modifying #{item}"
      Habit.new item
    end
  end
  
  def self.all
    @all ||= load || [Habit.new(title: "Double-tap here...")]
  end
  
  def self.next_unused_color_index
    return 0 unless @all
    result = @all.count + 1
    result = 0 if result >= COLORS.count
    result
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

end