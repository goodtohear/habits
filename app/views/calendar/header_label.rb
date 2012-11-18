# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class HeaderLabel < UILabel
  def initWithFrame(rect)
    if super(rect)
      self.textAlignment = UITextAlignmentCenter
      self.backgroundColor = UIColor.clearColor
      self.font = UIFont.fontWithName 'HelveticaNeue-Bold', size:20
      self.textColor = UIColor.whiteColor
    end
    self
  end
end