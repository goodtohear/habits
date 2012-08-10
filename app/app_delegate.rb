class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    
    @main = MainViewController.alloc.init
    @nav = UINavigationController.alloc.initWithRootViewController @main
    @window.rootViewController =  @nav
    @window.backgroundColor = "#ffffff".to_color

    @window.makeKeyAndVisible
    true
  end
  
  def applicationDidBecomeActive application

    Habit.reschedule_all_notifications
  end

end
