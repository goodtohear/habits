class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    Appearance.init()
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    
    @main = MainViewController.alloc.init
    @nav = UINavigationController.alloc.initWithRootViewController @main
    @window.rootViewController =  @nav
    @window.backgroundColor = "#ffffff".to_color

    @window.makeKeyAndVisible
    true
  end
  
  def applicationWillEnterForeground application
    Habit.reschedule_all_notifications
    @main.refresh
  end
  def applicationDidBecomeActive application
    @main.tableView.reloadData
  end
end
