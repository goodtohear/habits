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
    @scroller.addSubview icon
  end
  
  def addTitle text, y
    label = UILabel.alloc.initWithFrame [[35,y], [270, 12]]
    label.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 10
    label.textColor = "#999999".to_color
    label.text = text
    @scroller.addSubview label
  end
  
  def build
    self.navigationItem.title = ""

    view.autoresizesSubviews = false

    @scroller = UIScrollView.alloc.initWithFrame [[0, 44],[320, self.view.bounds.size.height - 44]]
    @scroller.showsVerticalScrollIndicator = false
    view.addSubview @scroller

    @navbar = UIImageView.alloc.initWithImage UIImage.imageNamed("nav")
    self.view.addSubview(@navbar)

    addTitleTextfield
    addBarButtons

    
    addIcon 'alarm', [13, 14]
    addTitle 'Reminders', 15
    addDateRangePicker 30
    addIcon 'clock', [13, 81]
    addTitle 'Days', 81 + 1
    addDayPicker 97
    addCalendar 146
    
    @scroller.contentSize = [320, CGRectGetMaxY(@calendar.view.frame)]

    # addIcon 'notes', [13,88]
    # addTitle 'Notes', 88
    
    dismissRangePickerAnimated false
    
    
    add_inactive_overlay
    
  end
  def addDayPicker y
    @days = DayPicker.alloc.initWithFrame [[PADDING, y],[320 - 2 * PADDING, 49]]
    @scroller.addSubview @days
  end
  def addCalendar y
    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,y], [320,276]]
    @calendar.dataSource = self
    @scroller.addSubview @calendar.view
    @calendar.showChainsForHabit @habit
  end
  def addTitleTextfield
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
  def addDateRangePicker y
    @reminders_button = Button.create [[10,y], [300,44]], color: Colors::COBALT
    updateRemindersButtonTitle
    @scroller.addSubview @reminders_button
    

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
  
  def addBarButtons
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