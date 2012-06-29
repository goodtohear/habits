class CalendarViewController < UIViewController
  # https://github.com/mattetti/BubbleWrap
  def loadView
    self.view = UIView.alloc.init
  end
  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor
    
    @button = UIButton.buttonWithType UIButtonTypeRoundedRect
    
    @button.frame =  [[20,20],[100,30]]
    
    self.view.addSubview @button
    @button.setTitle "HELLO", forState: UIControlStateNormal
    
    @button.when UIControlEventTouchUpInside do
      @next = UIViewController.alloc.init
      @next.title = "I am the next title"
      self.navigationController.pushViewController @next, animated: true
    end    
  end
end