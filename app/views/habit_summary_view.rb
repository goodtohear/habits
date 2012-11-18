# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class HabitSummaryView < UIView
  attr_accessor :habit

  def init
    if super
      build
    end
    self
  end
  
  def labelAtY y, fontSize: size
    label = UILabel.alloc.initWithFrame [[0,y], [320, size + 4]]
    label.font = UIFont.fontWithName "Helvetica-Bold", size: size
    label.backgroundColor = UIColor.clearColor
    label.textAlignment = UITextAlignmentCenter
    addSubview label
    label
  end
  
  def build
    @titleTextField = UITextField.alloc.initWithFrame [[0,8], [320,24]]
    @titleTextField.font = UIFont.fontWithName "Helvetica-Bold", size: 20
    @titleTextField.textAlignment = UITextAlignmentCenter
    @titleTextField.delegate = self
    addSubview @titleTextField
    
    @bigNumberLabel = labelAtY 32, fontSize: 60
    @unitLabel = labelAtY 91, fontSize: 18
    @totalLabel = labelAtY 114, fontSize: 8
    @highScoreLabel = labelAtY 126, fontSize: 8
    
    @deleteButton = UIButton.buttonWithType UIButtonTypeCustom
    @deleteButton.frame = [[0,8], [44,45]]
    @deleteButton.setImage UIImage.imageNamed("delete_off"), forState: UIControlStateNormal
    @deleteButton.setImage UIImage.imageNamed("delete_on"), forState: UIControlStateHighlighted
    @deleteButton.alpha = 0
    @deleteButton.enabled = false
    addSubview @deleteButton
    
    
    @deleteButton.when(UIControlEventTouchUpInside) do
      if @habit.blank?
        delete!
      else
        alert = UIAlertView.alloc.initWithTitle 'Delete this habit?', message: 'This cannot be undone', delegate: self, cancelButtonTitle: 'Cancel', otherButtonTitles: 'Delete'
        alert.show 
      end
    end
  end
  def alertView alertView, clickedButtonAtIndex: index
    if index > 0
      delete!
    end
  end
  
  def delete!
    @titleTextField.resignFirstResponder
    App.notification_center.post :ended_editing_habit
    UIView.animateWithDuration 0.4, animations: -> do
      self.alpha = 0
    end, completion:  -> (complete) do
      if complete
        Habit.delete(@habit)
      end
    end
  end
  
  def habit= value
    @habit = value
    @titleTextField.text = habit.title
    @bigNumberLabel.text = habit.currentChainLength.to_s
    @unitLabel.text = habit.currentChainLength == 1 ? "day" : "days"
    @totalLabel.text = "Total days: #{habit.totalDays}"
    @highScoreLabel.text = "Longest chain: #{habit.longestChain}"
  end
  
  # textField delegate
  def textFieldDidBeginEditing textField
    App.notification_center.post :began_editing_habit
    UIView.animateWithDuration 0.3, animations: -> do
      @deleteButton.enabled = true
      @bigNumberLabel.alpha = 0
      @deleteButton.alpha = 1
      @titleTextField.frame = [[0,19],@titleTextField.frame.size]
    end
    
  end
  def textFieldShouldReturn textField
    textField.resignFirstResponder
    true
  end
  def textFieldDidEndEditing textField
    @habit.title = textField.text
    
    UIView.animateWithDuration 0.3, animations: -> do
      @deleteButton.alpha = 0
      @deleteButton.enabled = false
      @bigNumberLabel.alpha = 1
      @titleTextField.frame = [[0,8],@titleTextField.frame.size ]
    end
    App.notification_center.post :ended_editing_habit
    true
  end
end