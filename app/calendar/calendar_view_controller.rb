class CalendarViewController < UIViewController
  # https://github.com/mattetti/BubbleWrap

  def viewDidLoad
    view.autoresizesSubviews = false
    
    @top = CalendarTopView.alloc.initWithFrame [[0,0],[320,54]]
    view.addSubview @top
    
    @scroller = UIScrollView.alloc.initWithFrame [[0,54], [320,220]]
    self.view.addSubview @scroller
    
    @this_month = MonthGridViewController.alloc.init
    @scroller.addSubview @this_month.view


   
    
  end
end