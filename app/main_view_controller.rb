class MainViewController < UIViewController
  def loadView
     self.view = UIScrollView.alloc.init
   end
   
  def init
    if super
      createSummaryViews
      build
      listen
    end
    self
  end
  
  def build
    self.view.autoresizesSubviews = false
    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,0], [320,276]]
    @calendar.dataSource = self
    view.addSubview @calendar.view
    
    @selector = SwipeSelectionViewController.alloc.init
    @selector.view.frame = [[0,276], [320, 460-276]]
    @selector.dataSource = self
    @selector.delegate = self
    view.addSubview @selector.view
    
    @selector.reloadData
    
    @divider = UIView.alloc.initWithFrame [[0,275], [320,1]]
    @divider.backgroundColor = '#8A95A1'.to_color
    view.addSubview @divider
    
    @info = UIButton.buttonWithType UIButtonTypeCustom
    @info.frame = [[4,412], [44,45]]
    @info.setImage UIImage.imageNamed("info_off"), forState: UIControlStateNormal
    @info.setImage UIImage.imageNamed("info_on"), forState: UIControlStateHighlighted
    view.addSubview @info
    
    @settings = UIButton.buttonWithType UIButtonTypeCustom
    @settings.frame = [[270,412], [44,45]]
    @settings.setImage UIImage.imageNamed("settings_off"), forState: UIControlStateNormal
    @settings.setImage UIImage.imageNamed("settings_on"), forState: UIControlStateHighlighted
    view.addSubview @settings
    
  end

  def listen
    App.notification_center.observe :began_editing_habit do |notification|
      # view.frame = [[0,20], [320,244]]
      view.setContentOffset [0,96], animated: true
    end
    App.notification_center.observe :ended_editing_habit do |notification|
      # view.frame = [[0,20],[320,460]]
      view.setContentOffset [0,0], animated: true
    end
    App.notification_center.observe :deleted_habit do |notification|
      @selector.reloadData
    end
  end
  
  #swiper delegate
  def swipeSelector selector, viewWasFocusedAtIndex: index
    NSLog "updated calendar to show #{Habit.all[index]} (habit #{index})"
  end
  #swiper datasource
  def swipeSelector selector, viewForIndex: index
    habit = Habit.all[index]
    result = @summaries[index]
    result.alpha = 1
    result.habit = habit 
    result
  end
  def swipeSelectorItemCount selector
    Habit.all.count
  end
  
  def swipeSelector selector, addItemAtIndex: index
    Habit.all.unshift Habit.new 
    new_view = HabitSummaryView.alloc.init
    new_view.alpha = 0
    @summaries.unshift new_view
    selector.reloadData
    UIView.animateWithDuration 0.4, animations: -> do
      new_view.alpha = 1
    end
  end
  
  
  def createSummaryViews
    @summaries = []
    for habit in Habit.all
      @summaries << HabitSummaryView.alloc.init
    end
  end
  
  # calendar delegate
  def calendar calendar, configureView: view, forDay: day
    
  end
  def calendar calendar, didChangeSelectionRange: range
    
  end
  
  
end