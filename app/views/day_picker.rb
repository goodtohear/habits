class DayPicker < UIView
  ITEM_WIDTH = 34
  VERTICAL_PADDING = 5
  SPACE = 8

  def initWithFrame frame
    if super frame
      build
    end
    self
  end
  def build
    applyBorder
    @dayButtons = []
    x = 8
    7.times do |n|
      frame = [[x, VERTICAL_PADDING],[ITEM_WIDTH, self.frame.size.height - VERTICAL_PADDING * 2 ]]
      day = Calendar::DAYS[n]
      isOn = true
      color = Colors::GREEN
      button = DayToggle.alloc.initWithFrame frame, day: day, color: color, isOn: isOn
      addSubview button
      
      button.when UIControlEventTouchUpInside do
        button.toggleOn !button.isOn
      end
      
      @dayButtons << button
      x += ITEM_WIDTH + SPACE
    end
  end
  def applyBorder
    layer.borderColor = "#b3b3b3".to_color.CGColor
    layer.borderWidth = 1
    layer.cornerRadius = 10
  end
end