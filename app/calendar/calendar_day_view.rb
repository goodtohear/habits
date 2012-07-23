class CalendarDayView < UIView
  attr_reader :label
  def initWithFrame(rect)
    if super
      @label = UILabel.alloc.initWithFrame [[0,0], frame.size]
      @label.textAlignment = UITextAlignmentCenter
      self.addSubview @label
      @label.text = "11"
      
    end
    self
  end
  
  def toggle isOn
    @label.textColor = isOn ? UIColor.redColor : UIColor.blackColor
  end
  
end