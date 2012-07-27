class MonthGridViewController < UIViewController
  CELL_SIZE = [45,44]
  CELL_INDICES = (0..7*5)
  attr_accessor :month, :firstDay
  
  SELECTION_STATES = :first_in_chain, :last_in_chain, :mid_chain, :missed, :future
  
  def loadView
    self.view = UIView.alloc.initWithFrame [[2,0], [315,45 * 5]]
  end
  
  def viewDidLoad
    next_x = 0
    next_y = 0
    @cells = []
    for grid_index in CELL_INDICES
      day = firstDay + grid_index.days
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
    @habit = habit
    for grid_index in CELL_INDICES
      cell = @cells[grid_index]
      comparison = Time.now > cell.day
      state = cellStateForHabit habit, date: cell.day
      cell.setSelectionState state, color: habit.color
    end
  end
  def cellStateForHabit habit, date: date
    return :before_start unless date
    return :future if (Time.now < date) 
    day = Time.local(date.year,date.month,date.day)
    if habit habit, includesDate: day
      if habit.days_checked.methods.include? :'item_before:' # class extensions don't seem to be applied immediately.
        item_before =  habit.days_checked.item_before(day)
        item_after = habit.days_checked.item_after(day)
        first_in_chain = !item_before || item_before && item_before < day - 1.day
        last_in_chain = !item_after || item_after && item_after > day + 1.day
        return :alone if first_in_chain && last_in_chain
        return :first_in_chain if first_in_chain
        return :last_in_chain if last_in_chain
      end
      return :mid_chain 
    end
    return :before_start if habit.earliest_date && date <= habit.earliest_date
    return :missed
  end
  def habit habit, includesDate: day
    for checked_day in habit.days_checked
      return true if checked_day >= day and (day + 1.day) > checked_day
    end
    false
  end
  
  # selection
  def touchesBegan touches, withEvent: event
    return unless @habit
    touch = touches.anyObject
    return unless touch.view.class == CalendarDayView
    @togglingOn = !habit( @habit, includesDate: touch.view.day)
    @daysTouched = [touch.view.day]
  end
  def touchesMoved touches, withEvent: event
    return unless @habit
    touch = touches.anyObject
    subview = view.hitTest touch.locationInView(view), withEvent: nil
    return unless subview.class == CalendarDayView
    day = subview.day
    subview.setSelectionState @togglingOn ? :mid_chain : :before_start, color: @habit.color
    @daysTouched << day unless @daysTouched.include? day
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