class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    @calendar = CalendarViewController.alloc.init
    @window.rootViewController =  UINavigationController.alloc.initWithRootViewController @calendar
    
    @window.makeKeyAndVisible
    true
  end
end
