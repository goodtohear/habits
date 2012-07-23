class CalendarDayView < UIView
  
  FUTURE_COLOR = '#8A95A1'.to_color
  MISSED_COLOR = '#C1272D'.to_color
  ON_COLOR = UIColor.whiteColor
  ON_BACKGROUND = '#3A4450'.to_color
  
  attr_reader :label
  def initWithFrame(rect)
    if super
      @label = UILabel.alloc.initWithFrame [[0,0], frame.size]
      @label.font = UIFont.fontWithName "Helvetica-Bold", size: 18
      @label.textColor = FUTURE_COLOR
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