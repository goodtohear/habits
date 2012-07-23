class HabitSummaryView < UIView
  attr_accessor :habit
  
  def init
    if super
      build
    end
    self
  end
  
  def build
    @titleTextField = UITextField.alloc.initWithFrame [[0,8], [320,20]]
    @titleTextField.font = UIFont.fontWithName "Helvetica-Bold", size: 20
    @titleTextField.textAlignment = UITextAlignmentCenter
    @titleTextField.delegate = self
    addSubview @titleTextField
  end
  def habit= value
    @habit = value
    
    @titleTextField.text = habit.title
    # result.setSummaryDays 8, unit: 'days', totalDays: 230, longestChain: 30
    
  end
  
  # textField delegate
  def textFieldDidBeginEditing textField
    App.notification_center.post :began_editing_habit
  end
  def textFieldShouldReturn textField
    textField.resignFirstResponder
    true
  end
  def textFieldDidEndEditing textField
    App.notification_center.post :ended_editing_habit
    true
  end
end