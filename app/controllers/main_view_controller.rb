class MainViewController < UITableViewController 
  SECTIONS = [:active, :inactive]
  
  def init
    if super
      build
    end
    self
  end

  def loadGroups
    @groups = [Habit.active,Habit.inactive]
  end
  
  def build
    loadGroups
    
    @now = Time.now
    
    self.view.dataSource = self
    self.view.reloadData

    @info_button = BarImageButton.alloc.initWithImageNamed('info')
    @info_button.when(UIControlEventTouchUpInside) do
      self.showInfo
    end
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithCustomView @info_button
    
    @add_button = BarImageButton.alloc.initWithImageNamed('add')
    @add_button.when(UIControlEventTouchUpInside) do
      self.addItem
    end
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithCustomView @add_button
     
    back =  UIBarButtonItem.alloc.init
    back.title = "BACK"
    self.navigationItem.backBarButtonItem = back
     
  end
  
  def refresh
    @now = Time.now
    @day_navigation.date = @now unless @day_navigation.nil?
    loadGroups
    self.view.reloadData
    
  end
  def viewWillAppear animated
    refresh()
    self.navigationItem.title = "GOOD HABITS"
  end
  def viewWillDisappear animated
    # self.navigationItem.title = "ALL"
  end
  def showInfo
    info = InformationScreen.alloc.init
    presentViewController info, animated: true, completion: ->(){}
  end
  def addItem
    new_habit = Habit.new
    Habit.all.push new_habit
    loadGroups
    section = SECTIONS.index(new_habit.active ? :active : :inactive)
    view.beginUpdates
    indexPath = NSIndexPath.indexPathForRow(@groups[section].count - 1, inSection: section)
    tableView.insertRowsAtIndexPaths [indexPath], withRowAnimation: UITableViewRowAnimationAutomatic
    view.endUpdates
    tableView tableView, didSelectRowAtIndexPath: indexPath
  end

  #swiper table dataSource
  def tableView tableView, numberOfRowsInSection: section_index
    return 0 if  @groups.nil? or @groups[section_index].nil?
    @groups[section_index].count
  end
  
  def numberOfSectionsInTableView tableView
    SECTIONS.count
  end

  def habitAtIndexPath(indexPath)
    @groups[section][indexPath.row]
  end

  CELLID = 'HabitRow'
  def tableView tableView, cellForRowAtIndexPath: indexPath
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = HabitCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      # cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end
    cell.now = @now
    habit = @groups[indexPath.section][indexPath.row]
    cell.habit = habit
    cell.set_color habit.color
    cell
  end
  
  def tableView tableView, heightForHeaderInSection: section
    if SECTIONS.index(:active) == section
      return 44
    end
    if SECTIONS.index(:inactive) == section
      return @groups[section].count > 0 ? 44 : 0
    end
  end
  
  def tableView tableView, viewForHeaderInSection: section
    if section == SECTIONS.index(:active)
      @day_navigation ||= DayNavigation.alloc.init
      @day_navigation.date = @now
      return @day_navigation
    end
    if section == SECTIONS.index(:inactive)
      return @inactive_title ||= InactiveHabitsHeader.alloc.init
    end
  end

  # swiper table delgate
  def tableView tableView, didSelectRowAtIndexPath:indexPath
    habit = @groups[indexPath.section][indexPath.row]
    detail = HabitDetailViewController.alloc.initWithHabit habit
    self.navigationController.pushViewController detail, animated: true
  end


end