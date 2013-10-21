# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class HabitDetailViewController < UIViewController
  TITLE_BUTTONS_WIDTH = 55
  PADDING = 3
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
    label = UILabel.alloc.initWithFrame [[13,y + LayoutHelper.top], [270, 12]]
    label.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 10
    label.textColor = "#999999".to_color
    label.text = text
    @scroller.addSubview label
  end
  
  def build
    statusBarBackground = UIView.alloc.initWithFrame [[0,0], [320,20]]
    statusBarBackground.backgroundColor = UIColor.blackColor
    view.addSubview statusBarBackground

    view.backgroundColor = UIColor.whiteColor
    self.navigationItem.title = ""

    view.autoresizesSubviews = false

    @scroller = UIScrollView.alloc.initWithFrame [[0, 44 + LayoutHelper.top],[320, self.view.bounds.size.height - 44 - LayoutHelper.top]]
    @scroller.showsVerticalScrollIndicator = false
    view.addSubview @scroller

    @navbar = UIImageView.alloc.initWithImage UIImage.imageNamed("nav")
    @navbar.frame = [[0, LayoutHelper.top], @navbar.frame.size]
    self.view.addSubview(@navbar)
    

    addTitleTextfield
    addBarButtons

    

    addTitle 'Reminder time', 15
    addDateRangePicker 30

    addTitle 'Days to do this', 81 + 1
    addDayPicker 97
    addCalendar 146
    
    @scroller.contentSize = [320, CGRectGetMaxY(@calendar.view.frame)]

    # addIcon 'notes', [13,88]
    # addTitle 'Notes', 88
    
    dismissRangePickerAnimated false
    
    
    add_inactive_overlay
    
  end
  def addDayPicker y
    @days = DayPicker.alloc.initWithFrame [[PADDING, y],[320 - 2 * PADDING, 48]], habit: @habit
    @days.delegate = self
    @scroller.addSubview @days
  end
  def dayPickerDidChange sender
    @calendar.showChainsForHabit @habit
  end
  def addCalendar y
    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,y], [320,276]]
    @calendar.dataSource = self
    @scroller.addSubview @calendar.view
    @calendar.showChainsForHabit @habit
  end
  def addTitleTextfield
    @titleTextField = UITextField.alloc.initWithFrame( [[PADDING + TITLE_BUTTONS_WIDTH,LayoutHelper.top],[320 - (PADDING + TITLE_BUTTONS_WIDTH) * 2,44]])
    @titleTextField.delegate = self
    @titleTextField.font = UIFont.fontWithName("HelveticaNeue-Bold", size:20)
    @titleTextField.textColor = UIColor.whiteColor
    @titleTextField.minimumFontSize = 15
    @titleTextField.textAlignment = UITextAlignmentCenter 
    @titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    @titleTextField.text = @habit.title
    view.addSubview(@titleTextField)
  end
  def addDateRangePicker y
    @reminders_button = Button.create [[PADDING,y], [320 - 2 * PADDING,44]], color: Colors::COBALT
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
    @active.frame = [[self.view.frame.size.width - TITLE_BUTTONS_WIDTH - PADDING, LayoutHelper.top], [TITLE_BUTTONS_WIDTH,44]]
    self.view.addSubview @active
    
    @back = UIButton.alloc.initWithFrame [[PADDING,LayoutHelper.top],[TITLE_BUTTONS_WIDTH,44]]
    @back.setBackgroundImage UIImage.imageNamed('back'), forState:UIControlStateNormal
    @back.setTitleColor Colors::COBALT, forState:UIControlStateNormal
    @back.setTitle "BACK", forState: UIControlStateNormal
    @back.setTitleColor(UIColor.whiteColor, forState:UIControlStateHighlighted)
    @back.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 12
    @back.titleEdgeInsets = [2, 13, 0, 4 ] # top left bottom right
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
    "Set reminder..."
  end
  def updateRemindersButtonTitle 
    
    @reminders_button.title = remindersButtonTitle
  end
  def showRemindersPickerAnimated animated
    t = (animated ? 0.3 : 0)
    @remindersPicker.hidden = false
    UIView.animateWithDuration t, animations: ->{
      @remindersPicker.frame = [[0,200], @remindersPicker.frame.size]
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
    super
    if @habit.is_new? and @habit.active
      @titleTextField.becomeFirstResponder
      @titleTextField.selectAll self
    end
  end
  
  def viewWillDisappear animated
    super
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
