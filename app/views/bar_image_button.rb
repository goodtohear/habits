# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class BarImageButton < UIControl
  
  def self.normalButtonWithImageNamed imageName
    result = UIBarButtonItem.alloc.init
    result.setImage UIImage.imageNamed(imageName), forState: UIControlStateNormal
    result
  end
  
end
