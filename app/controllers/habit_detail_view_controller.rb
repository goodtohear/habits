# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class HabitDetailViewController < UIViewController
  TITLE_BUTTONS_WIDTH = 55
  PADDING = 10
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
    self.navigationItem.title = ""

    view.autoresizesSubviews = false

    @navbar = UIImageView.alloc.initWithImage UIImage.imageNamed("nav")
    self.view.addSubview(@navbar)

    add_calendar
    add_title_textfield
    
    addIcon 'clock', [13,63]
    addTitle 'Reminders', 64
    # addIcon 'notes', [13,88]
    # addTitle 'Notes', 88
    
    add_date_range_picker
    dismissRangePickerAnimated false
    
    add_bar_buttons
    
    add_inactive_overlay
    
  end
  def add_calendar
    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,140], [320,276]]
    @calendar.dataSource = self
    view.addSubview @calendar.view
    @calendar.showChainsForHabit @habit
  end
  def add_title_textfield
    @titleTextField = UITextField.alloc.initWithFrame( [[PADDING + TITLE_BUTTONS_WIDTH,0],[320 - (PADDING + TITLE_BUTTONS_WIDTH) * 2,44]])
    @titleTextField.delegate = self
    @titleTextField.font = UIFont.fontWithName("HelveticaNeue-Bold", size:24)
    @titleTextField.textColor = UIColor.whiteColor
    @titleTextField.minimumFontSize = 15
    @titleTextField.textAlignment = UITextAlignmentCenter 
    @titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    @titleTextField.text = @habit.title
    view.addSubview(@titleTextField)
  end
  def add_date_range_picker
    @reminders_button = Button.create [[10,106-16], [300,44]], color: Colors::COBALT
    updateRemindersButtonTitle
    view.addSubview @reminders_button
    

    @reminders_button.when UIControlEventTouchUpInside do
      @titleTextField.resignFirstResponder
      showRemindersPickerAnimated true
    end

    @remindersPicker = ReminderRangePicker.alloc.initWithFrame [[0,156],[320,UIScreen.mainScreen.bounds.size.height-20-44-150]]
    @remindersPicker.setHabit @habit
    @remindersPicker.delegate = self
    view.addSubview @remindersPicker
    
  end
  
  def add_inactive_overlay
    @inactive_overlay = InactiveOverlayView.alloc.initWithFrame [[0,0],view.frame.size]
    view.addSubview @inactive_overlay
    
    updateActiveState false
    
    @inactive_overlay.delete.when(UIControlEventTouchUpInside) do
      Habit.delete @habit
      self.navigationController.popViewControllerAnimated true
      Habit.save!
    end
    @inactive_overlay.activate.when(UIControlEventTouchUpInside) do
      @habit.active = true
      Habit.save!
      updateActiveState
    end
    
    @inactive_overlay.done.when(UIControlEventTouchUpInside) do
      self.navigationController.popViewControllerAnimated true
    end
  end
  
  def add_bar_buttons
    # navigationItem.leftBarButtonItem.titleLabel.textColor = UIColor.blackColor
    @active = BarImageButton.normalButtonWithImageNamed('pause')
    @active.when(UIControlEventTouchUpInside) do
      self.toggleActive
    end
    @active.frame = [[self.view.frame.size.width - TITLE_BUTTONS_WIDTH - PADDING, 0], [TITLE_BUTTONS_WIDTH,44]]
    self.view.addSubview @active
    
    @back = UIButton.alloc.initWithFrame [[PADDING,0],[TITLE_BUTTONS_WIDTH,44]]
    @back.setBackgroundImage UIImage.imageNamed('back'), forState:UIControlStateNormal
    @back.setTitleColor Colors::COBALT, forState:UIControlStateNormal
    @back.setTitle "BACK", forState: UIControlStateNormal
    @back.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 14
    @back.titleEdgeInsets = [2, 10, 0, 5 ] # top left bottom right
    view.addSubview @back
    @back.when(UIControlEventTouchUpInside) do
      self.navigationController.popViewControllerAnimated(true)
    end
  end
  
  def updateActiveState animated=true
    image = UIImage.imageNamed( @habit.active ? 'pause' : 'play' )
    @active.setImage image, forState:UIControlStateNormal
    @active.accessibilityLabel = "Toggle paused: Currently #{@habit.active ? "active" : "paused"}"
    UIAccessibilityPostNotification UIAccessibilityLayoutChangedNotification, nil
    
    @inactive_overlay.toggleActive @habit.active, animated
  end
  def toggleActive
    @titleTextField.resignFirstResponder
    @habit.active = @habit.active ? false : true # inverting, also handling nil
    Habit.save!
    updateActiveState
  end
  
  def remindersButtonTitle
    unless (@habit.no_reminders?) 
      return "Remind at #{TimeHelper.hours[@habit.time_to_do]}"
    end
    "Set reminders..."
  end
  def updateRemindersButtonTitle 
    
    @reminders_button.title = remindersButtonTitle
  end
  def showRemindersPickerAnimated animated
    t = (animated ? 0.3 : 0)
    @remindersPicker.hidden = false
    UIView.animateWithDuration t, animations: ->{
      @remindersPicker.frame = [[0,156], @remindersPicker.frame.size]
    },completion: ->(complete){
       @calendar.view.hidden = true
       UIAccessibilityPostNotification UIAccessibilityLayoutChangedNotification, nil
    }
  end

  def dismissRangePickerAnimated animated
    updateRemindersButtonTitle
    t = (animated ? 0.3 : 0)
    @calendar.view.hidden = false
    UIView.animateWithDuration t, animations: ->{
      @remindersPicker.frame = [[0,UIScreen.mainScreen.bounds.size.height], @remindersPicker.frame.size]
    }, completion: ->(complete){
      @remindersPicker.hidden = true
      UIAccessibilityPostNotification UIAccessibilityLayoutChangedNotification, nil
    }
  end
  
  def viewDidAppear animated
    if @habit.is_new? and @habit.active
      @titleTextField.becomeFirstResponder
      @titleTextField.selectAll self
    end
  end
  
  def viewWillDisappear animated
    
    @titleTextField.resignFirstResponder
    @habit.title = @titleTextField.text
    Habit.save!
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