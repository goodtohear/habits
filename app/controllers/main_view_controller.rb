class MainViewController < UIViewController
  def loadView
     self.view = UIScrollView.alloc.init
   end
   
  def init
    if super
      build
      listen
    end
    self
  end
  
  LIST_FRAME_FULL = [[0,320], [320, 480-320]]
  LIST_FRAME_EDITING = [[0,320], [320, 44]]
  
  def build
    self.view.autoresizesSubviews = false
    
    @header = HeaderView.alloc.initWithFrame [[0,0],[320,44]]
    view.addSubview @header
    
    @selector = DragToAddTableView.alloc.initWithFrame LIST_FRAME_FULL
    @selector.dataSource = self
    @selector.tableViewDelegate = self
    view.addSubview @selector

    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,44], [320,276]]
    @calendar.dataSource = self
    view.addSubview @calendar.view
    
    @selector.reloadData
  end

  def listen
    App.notification_center.observe :began_editing_habit do |notification|
      view.setContentOffset [0,100], animated: true
      @selector.frame = LIST_FRAME_EDITING
      @selector.scrollToRowAtIndexPath @selector.indexPathForSelectedRow, atScrollPosition: UITableViewScrollPositionTop, animated: true
    end
    App.notification_center.observe :ended_editing_habit do |notification|
      view.setContentOffset [0,0], animated: true
      @selector.frame = LIST_FRAME_FULL
    end
    App.notification_center.observe :deleted_habit do |notification|
      @selector.reloadData
    end
  end
  
  #swiper table dataSource
  def tableView tableView, numberOfRowsInSection: section
    Habit.all.count
  end
  

  CELLID = 'HabitRow'
  def tableView tableView, cellForRowAtIndexPath: indexPath
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = HabitCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      # cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      cell
    end
    habit = Habit.all[indexPath.row]
    cell.habit = habit
    cell
  end
  
  
  # swiper table delgate
  def tableView tableView, didSelectRowAtIndexPath:indexPath
    habit = Habit.all[indexPath.row]
    @calendar.showChainsForHabit habit
  end
  
  def tableViewInsertNewRow tableView
    tableView.beginUpdates
    Habit.all.unshift Habit.new
    tableView.insertRowsAtIndexPaths [NSIndexPath.indexPathForRow(0, inSection: 0)], withRowAnimation: UITableViewRowAnimationAutomatic
    tableView.endUpdates
  end
  
  
  # calendar delegate
  def calendar calendar, configureView: view, forDay: day
    
  end
  def calendar calendar, didChangeSelectionRange: range
    
  end
  
  
end