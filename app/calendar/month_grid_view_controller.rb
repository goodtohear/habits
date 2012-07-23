class MonthGridViewController < UIViewController
  CELL_SIZE = [45,44]
  attr_accessor :month, :firstDay
  
  def loadView
    self.view = UIView.alloc.initWithFrame [[2,0], [315,45 * 5]]
  end
  
  def viewDidLoad
    next_x = 0
    next_y = 0
    @cells = []
    for grid_index in (0..7 * 5)
      day = firstDay + grid_index.days
      cell = CalendarDayView.alloc.initWithFrame( [[next_x,next_y], CELL_SIZE] )
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
  def reload
    
  end
end