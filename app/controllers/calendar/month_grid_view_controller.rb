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
      cell.setSelectionState habit.cellStateForDate cell.day
    end
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