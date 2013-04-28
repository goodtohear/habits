# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class BarImageButton < UIControl
  WIDTH = 34
  def initWithImageNamed(imageName)
    if init
      build(imageName)
    end
    self
  end
  def build(imageName)
    @image_view = UIImageView.alloc.initWithImage UIImage.imageNamed imageName
    @image_view.contentMode = UIViewContentModeCenter
    addSubview @image_view
    self.frame = [CGPointZero,[WIDTH, @image_view.frame.size.height]]
    @image_view.frame = self.frame
  end
  def setHighlighted highlighted
    super
    # self.backgroundColor = highlighted ? UIColor.blackColor : @color
    layer.opacity = highlighted ? 0.7 : 1
  end
  def image= image
    @image_view.image = image
  end
  
  def isAccessibilityElement
    true
  end
  
  
  def self.normalButtonWithImageNamed imageName
    result = UIButton.alloc.init
    result.setImage UIImage.imageNamed(imageName), forState: UIControlStateNormal
    result
  end
  
end