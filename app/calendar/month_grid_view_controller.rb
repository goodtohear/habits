class MonthGridViewController < UIViewController
  CELL_SIZE = 44
  def loadView
    self.view = UIView.alloc.initWithFrame [[2,0], [315,320]]
  end
  def viewDidLoad
    next_x = 0
    next_y = 0
    @days = []
    for n in (1..31)
      day = CalendarDayViewController.alloc.init 
      day.add_view CalendarDayView.alloc.initWithFrame( [[next_x,next_y], [CELL_SIZE,CELL_SIZE]] )
      day.view.label.text = "#{n}"
      self.view.addSubview day.view
      @days << day
      
      next_x += day.view.frame.size.width
      if next_x + CELL_SIZE > self.view.frame.size.width
        next_x = 0
        next_y += day.view.frame.size.height
      end
    end
    
  end
end