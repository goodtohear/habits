class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    
    @calendar = CalendarViewController.alloc.init
    @window.rootViewController =  UINavigationController.alloc.initWithRootViewController @calendar
    
    @settings_button = UIBarButtonItem.alloc.initWithTitle "⚙",style: UIBarButtonItemStyleBordered, target:self, action:'show_settings'
    @calendar.navigationItem.rightBarButtonItem = @settings_button

    @window.makeKeyAndVisible
    true
  end
  
  
  def show_settings
    settings = SettingsScreen.alloc.init
    @window.rootViewController.pushViewController(settings, animated:true)
  end
end
