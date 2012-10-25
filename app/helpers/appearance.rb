class Appearance
  def self.init
    UINavigationBar.appearance.setBackgroundImage UIImage.imageNamed("nav.png"), forBarMetrics: UIBarMetricsDefault
    UINavigationBar.appearance.setBackgroundColor "#3A4450".to_color
    UINavigationBar.appearance.setTitleTextAttributes UITextAttributeFont => UIFont.fontWithName('PlayfairDisplay-Italic', size: 20)
    UINavigationBar.appearance.setTitleVerticalPositionAdjustment -3, forBarMetrics: UIBarMetricsDefault
    
    UIBarButtonItem.appearanceWhenContainedIn(UINavigationBar,nil).setBackgroundImage UIImage.imageNamed("blank"), forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault
    backImage = UIImage.imageNamed("back").resizableImageWithCapInsets UIEdgeInsetsMake(10, 15, 10, 2) # top, left, bottom, right
    UIBarButtonItem.appearance.setBackButtonBackgroundImage  backImage, forState:UIControlStateNormal, barMetrics:UIBarMetricsDefault
    UIBarButtonItem.appearance.setTitleTextAttributes( {
      UITextAttributeTextColor => "#3A4450".to_color,
      UITextAttributeTextShadowColor => UIColor.clearColor,
      UITextAttributeFont => UIFont.fontWithName( "HelveticaNeue-Bold", size: 14)
      }, forState: UIControlStateNormal )
    
  end
end