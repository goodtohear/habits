class Labels
  def self.navbarLabelWithFrame frame
    result = UILabel.alloc.initWithFrame(frame)
    result.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    result.textColor = UIColor.whiteColor
    result.textAlignment = UITextAlignmentCenter
    result.backgroundColor = UIColor.clearColor
    result
  end
  def self.subheadingLabelWithFrame frame
    result = UILabel.alloc.initWithFrame(frame)
    result.backgroundColor = UIColor.clearColor
    result.textColor = UIColor.whiteColor
    result.textAlignment = UITextAlignmentLeft
    result.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 12
    result 
  end
end