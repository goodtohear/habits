class HabitCell < UITableViewCell
  attr_accessor :habit
  def initWithStyle style, reuseIdentifier: identifier
    if super
      build
    end
    self
  end
  
  def build
    @backgroundColorView = UIView.alloc.init
    setSelectedBackgroundView @backgroundColorView
    
    @input = UITextField.alloc.initWithFrame [[10,8],[250,30]]
    @input.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 20
    @input.userInteractionEnabled = false
    @input.delegate = self
    addSubview @input
    
    @doubleTap = UITapGestureRecognizer.alloc.initWithTarget self, action: 'doubleTapped'
    @doubleTap.numberOfTapsRequired = 2
    addGestureRecognizer @doubleTap
      
  end
  
  def doubleTapped
    edit
  end
  def edit
    @input.userInteractionEnabled = true
    @input.becomeFirstResponder
  end

  def setSelected selected, animated: animated
    super
    @input.textColor = selected ? UIColor.whiteColor : '#8A95A1'.to_color 
  end

  def habit= value
    @habit = value
    @input.text = @habit.title
    @backgroundColorView.backgroundColor = @habit.color
  end
  # textField delegate
  def textFieldDidBeginEditing textField
    textField.selectAll self
    App.notification_center.post :began_editing_habit, self
  end
  def textFieldShouldReturn textField
    textField.resignFirstResponder
    true
  end
  def textFieldDidEndEditing textField
    @habit.title = textField.text
    App.notification_center.post :ended_editing_habit, self
    @input.userInteractionEnabled = false
    true
  end
end