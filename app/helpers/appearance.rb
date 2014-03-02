# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class Appearance
  def self.remove
    UINavigationBar.appearance.setTitleTextAttributes UITextAttributeFont => UIFont.fontWithName('HelveticaNeue-Bold', size: 14)
  end
  def self.apply
    UINavigationBar.appearance.setTitleTextAttributes( 
      UITextAttributeFont => UIFont.fontWithName('HelveticaNeue-Bold', size: 20),
      UITextAttributeTextColor => UIColor.whiteColor
    ) 

    
  end
end
