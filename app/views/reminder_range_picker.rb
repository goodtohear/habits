# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class ReminderRangePicker < UIView
  attr_accessor :delegate
  def initWithFrame frame
    if super
      build
    end
    self
  end
  
  BAR_HEIGHT  = 44
  TIME_TO_DO_COMPONENT_INDEX = 0
  
  def createPicker
    result = UIDatePicker.alloc.initWithFrame [[0,BAR_HEIGHT],[320,self.frame.size.height - BAR_HEIGHT]]
    result.datePickerMode = UIDatePickerModeTime
    result.minuteInterval = 5
    result.backgroundColor = UIColor.whiteColor
    result.delegate = self
    addSubview(result)
    result
  end
  def build
    self.backgroundColor = UIColor.blackColor
    @options = TimeHelper.rotatedHours

    @toolbar = UIToolbar.alloc.initWithFrame [[0,0],[320,44]]
    @toolbar.items = [
      BarButton.button("CANCEL", style: UIBarButtonItemStyleBordered, target: self, action:'cancel'),
      BarButton.spacer,
      BarButton.button("CLEAR", style: UIBarButtonItemStylePlain, target: nil, action:'clear'),
      BarButton.spacer,
      BarButton.button("SAVE", style: UIBarButtonItemStyleDone, target: self, action:'save')
    ]
    addSubview(@toolbar)

    @picker = createPicker
  end
  
  
  def setHabit habit
  	@habit = habit
  	unless @habit.no_reminders?
      date = TimeHelper.time(@habit.time_to_do, @habit.minute_to_do)
      NSLog "Set picker date  #{date} for #{@habit.time_to_do}:#{@habit.minute_to_do}"
      @picker.setDate date, animated: false
    end
  end

  def cancel
    delegate.dismissRangePickerAnimated true
  end
  def clear
    @habit.time_to_do = ''
    Habit.save!
    delegate.dismissRangePickerAnimated true
  end

  def save
    date = @picker.date
  	@habit.time_to_do = date.hour
    @habit.minute_to_do = date.min
    NSLog "Saving reminder time #{date.hour}:#{date.min} (picker date #{date})"
    Habit.save!
    delegate.dismissRangePickerAnimated true
  end

end
