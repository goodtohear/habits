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
  DEADLINE_COMPONENT_INDEX = 1
  
  def createPicker
    result = UIPickerView.alloc.initWithFrame [[0,BAR_HEIGHT],[320,self.frame.size.height - BAR_HEIGHT]]
    result.dataSource = self
    result.delegate = self
    result.showsSelectionIndicator = true
    addSubview(result)
    result
  end
  def build
    
    @options = TimeHelper.rotatedHours

    @toolbar = UIToolbar.alloc.initWithFrame [[0,0],[320,44]]
    @toolbar.items = [
      BarButton.button("Clear", style: UIBarButtonItemStyleBordered, target: self, action:'clear'),
      BarButton.spacer,
      BarButton.button("Reminders", style: UIBarButtonItemStylePlain, target: nil, action:nil),
      BarButton.spacer,
      BarButton.button("Set", style: UIBarButtonItemStyleDone, target: self, action:'save')
    ]
    addSubview(@toolbar)

    @picker = createPicker
  end
  
  
  def setHabit habit
  	@habit = habit
  	unless @habit.no_reminders?
	  	@picker.selectRow TimeHelper.indexOfHour(@habit.time_to_do), inComponent:TIME_TO_DO_COMPONENT_INDEX, animated:false
		@picker.selectRow TimeHelper.indexOfHour(@habit.deadline), inComponent:DEADLINE_COMPONENT_INDEX, animated:false
	end
  end

  def clear
    @habit.time_to_do = ''
    @habit.deadline = ''
    Habit.save!
    delegate.dismissRangePickerAnimated true
  end

  def save
  	@habit.time_to_do = TimeHelper.hourForIndex( @picker.selectedRowInComponent(TIME_TO_DO_COMPONENT_INDEX) )
  	@habit.deadline = TimeHelper.hourForIndex( @picker.selectedRowInComponent(DEADLINE_COMPONENT_INDEX) )
  	Habit.save!
    delegate.dismissRangePickerAnimated true
  end

  def numberOfComponentsInPickerView pickerView
    2
  end
  def pickerView pickerView, numberOfRowsInComponent: component
    @options.count
  end
  def pickerView pickerView, titleForRow: row, forComponent: component
    time = @options[row]
    if component == TIME_TO_DO_COMPONENT_INDEX
      "Remind at #{time}"
    else
      "Deadline #{time}"
    end
  end
  def pickerView pickerView, didSelectRow: row, inComponent: component
  	deadline_is_before_time_to_do = pickerView.selectedRowInComponent(TIME_TO_DO_COMPONENT_INDEX) >= pickerView.selectedRowInComponent(DEADLINE_COMPONENT_INDEX)
	  if deadline_is_before_time_to_do
	    pickerView.selectRow [pickerView.selectedRowInComponent(TIME_TO_DO_COMPONENT_INDEX) + 1, @options.count - 1].min, inComponent:DEADLINE_COMPONENT_INDEX, animated:true
	  end
    
  end

  def pickerView pickerView, viewForRow: row, forComponent: component, reusingView: view
    view = PickerRowView.alloc.initWithFrame [[0,0],[130,14]] if view.nil?
    view.titleLabel.text = pickerView pickerView, titleForRow: row, forComponent: component
    view
  end
end