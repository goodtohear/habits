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
    return :before_start if date <= habit.created_at
    # return :first_in_chain 
    # return :last_in_chain
    day = Time.local(date.year,date.month,date.day)
    for checked_day in habit.days_checked
      return :mid_chain if checked_day >= day and (day + 1.day) > checked_day
    end
    return :missed
  end
  # selection
  def touchesBegan touches, withEvent: event
    touch = touches.anyObject
    @daysTouched = [touch.view.day]
  end
  def touchesMoved touches, withEvent: event
    touch = touches.anyObject
    NSLog "Touches moved #{touch.view.day}"
    @daysTouched << touch.view.day unless @daysTouched.include? touch.view.day
  end
  def touchesEnded touches, withEvent: event
    touch = touches.anyObject
    NSLog "days: #{@daysTouched}"
  end

end