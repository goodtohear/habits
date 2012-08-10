class MainViewController < UITableViewController 
  def init
    if super
      build
    end
    self
  end
 
  def build
    @sections = [
      { header: DayNavigationView.alloc.init, has_no_sections: true },
      
      { color: "C1272D", 
        predicate: :overdue?, 
        title: "TO DO, TODAY (OVERDUE)"  },
        
      { color: "F15A24", 
        predicate: :to_do_later?, 
        title: "TO DO"},
        
      { color: "77A247", 
        predicate: :done?, 
        title: "DONE" }
    ]
    
    @now = Time.now
    
    self.view.dataSource = self
    self.view.reloadData
    self.navigationItem.title = "Good Habits"
    
    @add_button = UIBarButtonItem.alloc.initWithTitle "+", style: UIBarButtonItemStyleDone,  target:self, action: 'addItem'
    self.navigationItem.rightBarButtonItem = @add_button
    
    
  end

  def addItem
    view.beginUpdates
    new_habit = Habit.new
    Habit.all.push new_habit
    indexPath = NSIndexPath.indexPathForRow(0, inSection: 2)
    tableView.insertRowsAtIndexPaths [indexPath], withRowAnimation: UITableViewRowAnimationAutomatic
    view.endUpdates
  end

  #swiper table dataSource
  def tableView tableView, numberOfRowsInSection: section_index
    section = @sections[section_index]
    return 0 if section[:has_no_sections]
    return habitsForSection(section_index).count
  end
  
  def numberOfSectionsInTableView tableView
    @sections.count
  end

  def habitsForSection(section)
    Habit.all.select{|habit| habit.send @sections[section][:predicate], Time.now  }
  end
  
  def habitAtIndexPath(indexPath)
    habitsForSection(indexPath.section)[indexPath.row]
  end

  def tableView tableView, viewForHeaderInSection: section_index
    section = @sections[section_index]
    return section[:header] unless section[:header].nil?
    super
  end
  
  def tableView tableView, titleForHeaderInSection: section
    return @sections[section][:title]
  end
  

  CELLID = 'HabitRow'
  def tableView tableView, cellForRowAtIndexPath: indexPath
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = HabitCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      cell
    end
    cell.now = @now
    habit = self.habitAtIndexPath(indexPath)
    cell.habit = habit
    cell.set_color habit.color
    cell
  end
  

    
  # swiper table delgate
  def tableView tableView, didSelectRowAtIndexPath:indexPath
    habit = self.habitAtIndexPath(indexPath)
    detail = HabitDetailViewController.alloc.initWithHabit habit
    self.navigationController.pushViewController detail, animated: true
  end


end