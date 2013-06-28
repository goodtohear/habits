class InfoCountBadge < UIView
  def initWithFrame frame
    if super
      build
      refresh
    end
    self
  end
  def build
    self.setUserInteractionEnabled(false)
    self.backgroundColor = Colors::RED
    @label = UILabel.alloc.initWithFrame [[0,1],self.frame.size]
    @label.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 14
    @label.textColor = UIColor.whiteColor
    @label.backgroundColor = UIColor.clearColor
    @label.textAlignment = UITextAlignmentCenter
    addSubview @label
  end 
  def refresh
    count = InfoTask.unopened_count
    @label.text = "#{count}"
    self.alpha = count == 0 ? 0 : 1
  end
end