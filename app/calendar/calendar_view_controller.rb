class CalendarViewController < UIViewController
  # https://github.com/mattetti/BubbleWrap
  def loadView
    self.view = UIView.alloc.init
  end
  def viewDidLoad
    self.title = "Keep it up"
    self.view.backgroundColor = UIColor.whiteColor # UIColor.colorWithPatternImage UIImage.imageNamed 'fabric_1'
    
    @scroller = UIScrollView.alloc.initWithFrame [[0,88], [320,320]]
    self.view.addSubview @scroller
    
    @this_month = MonthGridViewController.alloc.init
    @scroller.addSubview @this_month.view
    self.view.addSubview UIImageView.alloc.initWithImage( UIImage.imageNamed 'calendar_top')

    @label = HeaderLabel.alloc.initWithFrame [[0,16],[320,14]]
    self.view.addSubview @label

    @label.text = "JANUARY 2012"
    
    @prev_button = NavButton.alloc.initWithFrame [[0,0], [44,44]]
    self.view.addSubview @prev_button
    
    @next_button = NavButton.alloc.initWithFrame [[320-44,0],[44,44]]
    @next_button.point :right
    self.view.addSubview @next_button
    
  end
end