# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class BarButton
  def self.with_title text
    
  end
  def self.button(title, style: style, target: target, action: action)
    result = UIBarButtonItem.alloc.initWithTitle(title, style: style, target: target, action: action)
    result.setTitleTextAttributes( {
      UITextAttributeTextColor => UIColor.whiteColor,
      UITextAttributeTextShadowColor => UIColor.clearColor,
      UITextAttributeFont => UIFont.fontWithName( "HelveticaNeue-Bold", size: 14)
      }, forState: UIControlStateNormal )
    result
  end
  def self.spacer
    UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target:nil, action:nil)
  end
end