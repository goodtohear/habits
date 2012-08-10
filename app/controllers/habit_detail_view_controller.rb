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
    self.navigationItem.title = "Habit"
    back =  UIBarButtonItem.alloc.init
    back.title = "Back"
    self.navigationItem.backBarButtonItem = back # not doing anything
    view.autoresizesSubviews = false

    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,140], [320,276]]
    @calendar.dataSource = self
    view.addSubview @calendar.view
    @calendar.showChainsForHabit @habit
    
    @titleTextField = UITextField.alloc.initWithFrame([[0,24],[320,20]])
    @titleTextField.delegate = self
    @titleTextField.font = UIFont.fontWithName("HelveticaNeue-Bold", size:16)
    @titleTextField.textAlignment = UITextAlignmentCenter 
    @titleTextField.text = @habit.title
    view.addSubview(@titleTextField)

    addIcon 'clock', [13,88 - 16]
    addTitle 'Reminders', 89 - 16
    # addIcon 'notes', [13,88]
    # addTitle 'Notes', 88
    
    
    @reminders_button = UIButton.buttonWithType UIButtonTypeRoundedRect
    @reminders_button.frame = [[10,106-16], [300,44]]
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
    unless (@habit.no_reminders?) 
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

  # title text field
  def textFieldShouldReturn textField
    textField.resignFirstResponder
    true
  end
  def textFieldDidEndEditing textField
    @habit.title = textField.text
    Habit.save!
    true
  end
end