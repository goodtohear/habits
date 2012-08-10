class HabitDetailViewController < UIViewController
  def initWithHabit habit
    if init
      @habit = habit
      build
    end
    self
  end
  
  def addIcon name, position
    icon = UIImageView.alloc.initWithImage UIImage.imageNamed name
    icon.frame = [position, icon.frame.size]
    view.addSubview icon
    
  end
  def addTitle text, y
    label = UILabel.alloc.initWithFrame [[35,y], [270, 12]]
    label.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 10
    label.textColor = "#999999".to_color
    label.text = text
    view.addSubview label
  end
  
  def build
    view.autoresizesSubviews = false

    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,140], [320,276]]
    @calendar.dataSource = self
    view.addSubview @calendar.view
    @calendar.showChainsForHabit @habit
    
    addIcon 'clock', [13,14]
    addTitle 'Reminders', 15
    addIcon 'notes', [13,88]
    addTitle 'Notes', 88
    
    
    @reminders_button = UIButton.buttonWithType UIButtonTypeRoundedRect
    @reminders_button.frame = [[10,35], [300,44]]
    updateRemindersButtonTitle
    view.addSubview @reminders_button
    

    @reminders_button.when UIControlEventTouchUpInside do
      showRemindersPickerAnimated true
    end

    @remindersPicker = ReminderRangePicker.alloc.initWithFrame [[0,156],[320,480-20-44-150]]
    @remindersPicker.setHabit @habit
    @remindersPicker.delegate = self
    view.addSubview @remindersPicker
    dismissRangePickerAnimated false
    
  end
  def remindersButtonTitle
    unless (@habit.time_to_do.nil? or @habit.deadline.nil?) 
      return "Do at about #{TimeHelper.hours[@habit.time_to_do]}. Last chance #{TimeHelper.hours[@habit.deadline]}"
    end
    "Set reminders..."
  end
  def updateRemindersButtonTitle 
    
    @reminders_button.setTitle remindersButtonTitle, forState: UIControlStateNormal
  end
  def showRemindersPickerAnimated animated
    t = (animated ? 0.3 : 0)
    UIView.animateWithDuration t, animations: ->{
      @remindersPicker.frame = [[0,156], @remindersPicker.frame.size]
    }
  end

  def dismissRangePickerAnimated animated
    updateRemindersButtonTitle
    t = (animated ? 0.3 : 0)
    UIView.animateWithDuration t, animations: ->{
      @remindersPicker.frame = [[0,480], @remindersPicker.frame.size]
    }
  end

end