class CountView < UIView
  def initWithFrame frame
    if super 
      build
    end
    self
  end

  def build
    @label = UILabel.alloc.initWithFrame [[0,0],frame.size]
    @label.textAlignment = UITextAlignmentCenter
    @label.backgroundColor = UIColor.clearColor
    @label.textColor = UIColor.whiteColor
    @label.font = UIFont.boldSystemFontOfSize 12
    addSubview @label

    self.backgroundColor = "#AAAAAA".to_color
    layer.cornerRadius = 12

  end

  def text= value
    @label.text = "#{value}"
  end

end