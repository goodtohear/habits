# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class MonthGridViewController < UIViewController
  CELL_SIZE = [45,44]
  CELL_INDICES = (0..7*5)
  attr_accessor :month, :firstDay
  
  SELECTION_STATES = :first_in_chain, :last_in_chain, :mid_chain, :missed, :future, :alone, :not_required, :between_subchains # subchains are segments of chains between required days of the week
  STATE_LABEL = {
    first_in_chain: "first in chain",
    before_start: "before start",
    not_required: "not required",
    last_in_chain: "last in chain",
    mid_chain: "mid-chain",
    missed: "missed day",
    future: "future",
    alone: "isolated day",
    between_subchains: "between subchains"

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
    @tap = UITapGestureRecognizer.alloc.initWithTarget self, action:'tapped'
    view.addGestureRecognizer @tap
    
  end
  
  
  #
  def showChainsForHabit habit
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

    day_after = day + 1.day

    if habit.includesDate day
      first_in_chain = !habit.continuesActivityBefore(day)
      last_in_chain = !habit.continuesActivityAfter(day)  || Time.now < day_after
      alone = first_in_chain && last_in_chain

      return :alone if alone
      return :first_in_chain if first_in_chain
      return :last_in_chain if last_in_chain
      return :mid_chain 
    end
    return :before_start if habit.earliest_date && date <= habit.earliest_date
    
    unless habit.days_required[date.wday]
      return :between_subchains if habit.continuesActivityBefore(day) && habit.continuesActivityAfter(day)
      return :not_required 
    end
    return :missed
  end
  

  def isFutureDate(day)
    day > Time.now
  end
  

  def tapped 
    location = @tap.locationInView(view)
    subview = view.hitTest location, withEvent: nil
    if subview.class == CalendarDayView
      return if isFutureDate(subview.day)
      togglingOn = !@habit.includesDate(subview.day)
      subview.setSelectionState @togglingOn ? :alone : :before_start, color: @habit.color
      if togglingOn
        @habit.check_days [subview.day]
      else
        @habit.uncheck_days [subview.day]
      end
      Habit.save!
      showChainsForHabit @habit
    end
  end
end