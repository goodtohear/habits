class HabitCell < UITableViewCell
  attr_accessor :habit, :now
  def initWithStyle style, reuseIdentifier: identifier
    if super
      build
    end
    self
  end
  
  def build
    @backgroundColorView = UIView.alloc.init
    # setSelectedBackgroundView @backgroundColorView
    self.selectionStyle = UITableViewCellSelectionStyleNone
    @input = UITextField.alloc.initWithFrame [[50,8],[210,30]]
    @input.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 20
    @input.userInteractionEnabled = false
    @input.delegate = self
    addSubview @input
    
    @doubleTap = UITapGestureRecognizer.alloc.initWithTarget self, action: 'doubleTapped'
    @doubleTap.numberOfTapsRequired = 2
    addGestureRecognizer @doubleTap
    
    
    @checkbox = CheckBox.alloc.initWithFrame [[0,0], [44,44]]
    addSubview @checkbox
    @checkbox.whenTapped do
      @habit.toggle @now
      @checkbox.set_checked @habit.done? @now
    end
      
  end
  def set_color color
    @checkbox.set_color color
    # @backgroundColorView.backgroundColor = color
  end
  
  def doubleTapped
    edit
  end
  def edit
    @input.userInteractionEnabled = true
    @input.becomeFirstResponder
  end

  #def setSelected selected, animated: animated
  #  super
  #  @input.textColor = selected ? UIColor.whiteColor : '#8A95A1'.to_color 
  #end

  def habit= value
    @habit = value
    @checkbox.set_checked @habit.done? @now
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
    Habit.save!
    true
  end
end