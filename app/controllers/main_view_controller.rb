class MainViewController < UITableViewController 
  def init
    if super
      build
    end
    self
  end

  def build
    @now = Time.now
    
    self.view.dataSource = self
    self.view.reloadData
    
    @add_button = UIBarButtonItem.alloc.initWithImage UIImage.imageNamed("add"), style: UIBarButtonItemStyleDone,  target:self, action: 'addItem'
    self.navigationItem.rightBarButtonItem = @add_button
  end
  def refresh
    self.view.reloadData    
  end
  def viewWillAppear animated
    refresh()
    self.navigationItem.title = "Good Habits"
  end
  def viewWillDisappear animated
    self.navigationItem.title = "All"
  end

  def addItem
    view.beginUpdates
    new_habit = Habit.new
    Habit.all.push new_habit
    indexPath = NSIndexPath.indexPathForRow(Habit.all.count - 1, inSection: 0)
    tableView.insertRowsAtIndexPaths [indexPath], withRowAnimation: UITableViewRowAnimationAutomatic
    view.endUpdates
    tableView tableView, didSelectRowAtIndexPath: indexPath
  end

  #swiper table dataSource
  def tableView tableView, numberOfRowsInSection: section_index
    return Habit.all.count
  end
  
  def numberOfSectionsInTableView tableView
    1
  end

  def habitAtIndexPath(indexPath)
    Habit.all[indexPath.row]
  end

  CELLID = 'HabitRow'
  def tableView tableView, cellForRowAtIndexPath: indexPath
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = HabitCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end
    cell.now = @now
    habit = Habit.all[indexPath.row]
    cell.habit = habit
    cell.set_color habit.color
    cell
  end
  
  def tableView tableView, heightForHeaderInSection: section
    44
  end
  
  def tableView tableView, viewForHeaderInSection: section
    @day_navigation ||= DayNavigation.alloc.init
    @day_navigation.date = @now
    @day_navigation
  end

  # swiper table delgate
  def tableView tableView, didSelectRowAtIndexPath:indexPath
    habit = Habit.all[indexPath.row]
    detail = HabitDetailViewController.alloc.initWithHabit habit
    self.navigationController.pushViewController detail, animated: true
  end


end