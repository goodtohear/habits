# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class PickerRowView < UIView
  attr_reader :titleLabel
  def initWithFrame frame
    if super
      build()
    end
    self
  end
  def build
    @titleLabel = UILabel.alloc.initWithFrame [[0,0],frame.size]
    @titleLabel.backgroundColor = UIColor.clearColor
    @titleLabel.font = UIFont.fontWithName("HelveticaNeue-Bold", size:14)
    addSubview(@titleLabel)
  end
end