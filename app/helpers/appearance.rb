# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class Appearance
  def self.remove
    UINavigationBar.appearance.setTitleTextAttributes UITextAttributeFont => UIFont.fontWithName('HelveticaNeue-Bold', size: 14)
  end
  def self.apply
    UINavigationBar.appearance.setBackgroundImage UIImage.imageNamed("nav.png"), forBarMetrics: UIBarMetricsDefault
    UINavigationBar.appearance.setBackgroundColor "#3A4450".to_color
    UINavigationBar.appearance.setTitleTextAttributes UITextAttributeFont => UIFont.fontWithName('HelveticaNeue-Bold', size: 20)
    # UINavigationBar.appearance.setTitleVerticalPositionAdjustment -3, forBarMetrics: UIBarMetricsDefault
    
    UIBarButtonItem.appearanceWhenContainedIn(UINavigationBar,nil).setBackgroundImage UIImage.imageNamed("blank"), forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault
    backImage = UIImage.imageNamed("back").resizableImageWithCapInsets UIEdgeInsetsMake(10, 15, 10, 2) # top, left, bottom, right

    UIBarButtonItem.appearance.setBackButtonBackgroundImage  backImage, forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault


    UIBarButtonItem.appearance.setTitleTextAttributes( {
      UITextAttributeTextColor => "#3A4450".to_color,
      UITextAttributeTextShadowColor => UIColor.clearColor,
      UITextAttributeFont => UIFont.fontWithName( "HelveticaNeue-Bold", size: 14)
      }, forState: UIControlStateNormal )

    UIBarButtonItem.appearance.setTitleTextAttributes( {
      UITextAttributeTextColor => UIColor.whiteColor
      }, forState: UIControlStateHighlighted )
  end
end