# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
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
    @main.refresh
  end
  def applicationWillResignActive application
    Notifications.reschedule!
  end
  def applicationDidBecomeActive application
    @main.tableView.reloadData
  end
end
