class HeaderLabel < UILabel
  def initWithFrame(rect)
    if super(rect)
      self.textAlignment = UITextAlignmentCenter
      self.textColor = UIColor.whiteColor
      self.backgroundColor = UIColor.clearColor

      self.layer.shadowColor = UIColor.redColor.CGColor
      self.layer.shadowOffset = [0,3]
      self.layer.shadowRadius = 20
      self.layer.masksToBounds = false
      self.layer.shadowOpacity = 0.4

      self.font = UIFont.fontWithName 'HelveticaNeue-Bold', size:12
      
    end
    self
  end
end