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
    result = UIPickerView.alloc.initWithFrame [[0,BAR_HEIGHT],[320,self.frame.size.height - BAR_HEIGHT]]
    result.dataSource = self
    result.delegate = self
    result.showsSelectionIndicator = true
    addSubview(result)
    result
  end
  def build
    self.backgroundColor = UIColor.blackColor
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
	end
  end

  def clear
    @habit.time_to_do = ''
    Habit.save!
    delegate.dismissRangePickerAnimated true
  end

  def save
  	@habit.time_to_do = TimeHelper.hourForIndex( @picker.selectedRowInComponent(TIME_TO_DO_COMPONENT_INDEX) )
  	Habit.save!
    delegate.dismissRangePickerAnimated true
  end

  def numberOfComponentsInPickerView pickerView
    1
  end
  def pickerView pickerView, numberOfRowsInComponent: component
    @options.count
  end
  def pickerView pickerView, titleForRow: row, forComponent: component
    time = @options[row]
    "Remind at #{time}"
  end

  def pickerView pickerView, viewForRow: row, forComponent: component, reusingView: view
    view = PickerRowView.alloc.initWithFrame [[0,0],[230,14]] if view.nil?
    view.titleLabel.text = pickerView pickerView, titleForRow: row, forComponent: component
    view
  end
end