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
    
    @header = HeaderView.alloc.initWithFrame [[0,0],[320,44]]
    view.addSubview @header
    
    @selector = SwipeSelectionViewController.alloc.init
    @selector.view.frame = [[0,320], [320, 460-320]]
    @selector.dataSource = self
    @selector.delegate = self
    view.addSubview @selector.view
    
    
    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,44], [320,276]]
    @calendar.dataSource = self
    view.addSubview @calendar.view

    
    @selector.reloadData
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
    habit = Habit.all[index]
    @calendar.showChainsForHabit habit
    
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