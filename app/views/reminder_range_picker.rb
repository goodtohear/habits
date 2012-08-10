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
  FIRST_OPTION_OFFSET = 6 # must be >= 0
  def createPicker
    result = UIPickerView.alloc.initWithFrame [[0,BAR_HEIGHT],[320,self.frame.size.height - BAR_HEIGHT]]
    result.dataSource = self
    result.delegate = self
    result.showsSelectionIndicator = true
    addSubview(result)
    result
  end
  def build
    
    @options = TimeHelper.hours.rotate(FIRST_OPTION_OFFSET)

    @toolbar = UIToolbar.alloc.initWithFrame [[0,0],[320,44]]
    @toolbar.items = [
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCancel, target:self, action:'cancel'),
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil),
      UIBarButtonItem.alloc.initWithTitle("Reminders", style: UIBarButtonItemStylePlain, target: nil, action:nil),
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil),
      UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target:self, action:'save')
    ]
    addSubview(@toolbar)

    @picker = createPicker
  end
  
  def rowIndexOfHour hour
  	return 0 if hour.nil?
  	hour -= FIRST_OPTION_OFFSET 
  	hour += 24 if hour < 0
  	hour
  end

  def hourForRowIndex index
  	index += FIRST_OPTION_OFFSET
  	index -= 24 if index > 23 
  	index
  end
  def setHabit habit
  	@habit = habit
  	unless @habit.no_reminders?
	  	@picker.selectRow rowIndexOfHour(@habit.time_to_do), inComponent:TIME_TO_DO_COMPONENT_INDEX, animated:false
		@picker.selectRow rowIndexOfHour(@habit.deadline), inComponent:DEADLINE_COMPONENT_INDEX, animated:false
	end
  end

  def cancel
    delegate.dismissRangePickerAnimated true
  end

  def save
  	@habit.time_to_do = hourForRowIndex( @picker.selectedRowInComponent(TIME_TO_DO_COMPONENT_INDEX) )
  	@habit.deadline = hourForRowIndex( @picker.selectedRowInComponent(DEADLINE_COMPONENT_INDEX) )
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
    if component == TIME_TO_DO_COMPONENT_INDEX
      if row >= pickerView.selectedRowInComponent(DEADLINE_COMPONENT_INDEX)
        pickerView.selectRow [row + 1, @options.count - 1].min, inComponent:DEADLINE_COMPONENT_INDEX, animated:true
      end
    end
  end

  def pickerView pickerView, viewForRow: row, forComponent: component, reusingView: view
    view = PickerRowView.alloc.initWithFrame [[0,0],[130,14]] if view.nil?
    view.titleLabel.text = pickerView pickerView, titleForRow: row, forComponent: component
    view
  end
end