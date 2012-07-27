class HabitCell < UITableViewCell
  attr_accessor :habit
  def initWithStyle style, reuseIdentifier: identifier
    if super
      build
    end
    self
  end
  
  def build
    @input = UITextField.alloc.initWithFrame [[10,8],[250,30]]
    @input.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 20
    @input.textColor = '#8A95A1'.to_color
    @input.userInteractionEnabled = false
    @input.delegate = self
    addSubview @input
    
    @doubleTap = UITapGestureRecognizer.alloc.initWithTarget self, action: 'doubleTapped'
    @doubleTap.numberOfTapsRequired = 2
    addGestureRecognizer @doubleTap
      
  end
  
  def doubleTapped
    @input.userInteractionEnabled = true
    @input.becomeFirstResponder
  end

  def habit= value
    @habit = value
    @input.text = @habit.title
  end
  # textField delegate
  def textFieldDidBeginEditing textField
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