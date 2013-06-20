class DayToggle < UIButton
  attr_reader :isOn

  def initWithFrame frame, day: day, color: color, isOn: isOn
    if initWithFrame frame
      @day = day
      @color = color
      build
      toggleOn isOn
    end
    self
  end
  
  def build
    addLabel
    addCheckmark
    toggleOn true
  end
  
  def addLabel
    @title = UILabel.alloc.initWithFrame [[0,0],[self.frame.size.width,18]]
    @title.textAlignment = UITextAlignmentCenter
    @title.textColor = UIColor.whiteColor
    @title.font = UIFont.fontWithName "HelveticaNeue-Light", size: 10
    @title.backgroundColor = UIColor.clearColor
    addSubview @title
    @title.text = @day
  end
  
  def addCheckmark
    @checkmark = UIImageView.alloc.initWithImage UIImage.imageNamed "check_mark"
    @checkmark.frame = [[8,19],@checkmark.frame.size]
    addSubview @checkmark
  end
  
  def toggleOn isOn
    @isOn = isOn
    @checkmark.hidden = !isOn

  end
  
end