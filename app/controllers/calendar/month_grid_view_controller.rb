# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class MonthGridViewController < UIViewController
  CELL_SIZE = [45,44]
  CELL_INDICES = (0..7*5)
  attr_accessor :month, :firstDay
  
  SELECTION_STATES = :first_in_chain, :last_in_chain, :mid_chain, :missed, :future, :alone
  STATE_LABEL = {
    first_in_chain: "first in chain",
    last_in_chain: "last in chain",
    mid_chain: "mid-chain",
    missed: "missed day",
    future: "future",
    alone: "isolated day"
  }
  def loadView
    self.view = UIView.alloc.initWithFrame [[2,0], [315,45 * 5]]
  end
  
  def viewDidLoad
    @queue = Dispatch::Queue.concurrent('goodtohear.habits.calendar')
    next_x = 0
    next_y = 0
    @cells = []
    components = NSDateComponents.alloc.init
    for grid_index in CELL_INDICES
      components.day = grid_index
      day = NSCalendar.currentCalendar.dateByAddingComponents components, toDate: firstDay, options: 0
      cell = CalendarDayView.alloc.initWithFrame( [[next_x + 1,next_y], [CELL_SIZE[0], 43]] )
      cell.day = day
      cell.label.text = "#{day.day}"

      self.view.addSubview cell
      @cells << cell
      next_x += cell.frame.size.width
      if next_x + CELL_SIZE[0] > self.view.frame.size.width
        next_x = 0
        next_y += CELL_SIZE[1]
      end
    end
  end
  #
  def showChainsForHabit habit
    return unless Array.instance_methods.include? :'item_before:' # in case called before class extensions applied
    @habit = habit
    Dispatch::Queue.concurrent.async do
      for grid_index in CELL_INDICES
        cell = @cells[grid_index]
        comparison = Time.now > cell.day
        state = MonthGridViewController.cellStateForHabit habit, date: cell.day
        Dispatch::Queue.main.sync do
          cell.setSelectionState state, color: habit.color
          cell.accessibilityLabel = cell.day.strftime('%d %B') + ", " + STATE_LABEL[state]
        end
      end
    end
  end
  def self.cellStateForHabit habit, date: date
    return :before_start unless date
    return :future if (Time.now < date) 
    day = Time.local(date.year,date.month,date.day)
    if habit habit, includesDate: day
      item_before =  habit.days_checked.item_before(day)
      item_after = habit.days_checked.item_after(day)

      NSLog "item_before: #{item_before}, day: #{day} days_checked: #{habit.days_checked.join('\n')}"
      NSLog "item_before: #{TimeHelper.daysBetweenDate(item_before, andDate: day).day}" if item_before
      NSLog "item_after: #{TimeHelper.daysBetweenDate(day, andDate: item_after).day}" if item_after
      
 
      first_in_chain = !item_before || item_before && TimeHelper.daysBetweenDate(item_before, andDate: day).day > 1.5
      last_in_chain = !item_after || item_after && TimeHelper.daysBetweenDate(day, andDate: item_after).day > 1.5 
      return :alone if first_in_chain && last_in_chain
      return :first_in_chain if first_in_chain
      return :last_in_chain if last_in_chain
      return :mid_chain 
    end
    return :before_start if habit.earliest_date && date <= habit.earliest_date
    return :missed
  end
  def self.habit habit, includesDate: day
    # assume goes forward
    for checked_day in habit.days_checked
      return true if checked_day >= day and (day + 1.day) > checked_day
      return false if checked_day > day
    end
    false
  end
  
  def isFutureDate(day)
    day > Time.now
  end
  
  # selection
  def touchesBegan touches, withEvent: event
    return unless @habit
    touch = touches.anyObject
    subview = touch.view
    return unless subview.class == CalendarDayView
    
    @togglingOn = !MonthGridViewController.habit( @habit, includesDate: subview.day)
    subview.setSelectionState @togglingOn ? :alone : :before_start, color: @habit.color
    
    @daysTouched = []
    @daysTouched << touch.view.day unless isFutureDate(touch.view.day)
  end
  def touchesMoved touches, withEvent: event
    return unless @habit
    touch = touches.anyObject
    subview = view.hitTest touch.locationInView(view), withEvent: nil
    return unless subview.class == CalendarDayView
    day = subview.day
    subview.setSelectionState @togglingOn ? :alone : :before_start, color: @habit.color
    @daysTouched << day unless @daysTouched.include?(day) or isFutureDate(day)
  end
  def touchesEnded touches, withEvent: event
    return unless @habit
    touch = touches.anyObject
    if @togglingOn
      @habit.check_days @daysTouched
    else
      @habit.uncheck_days @daysTouched
    end
    Habit.save!
    showChainsForHabit @habit
  end

end