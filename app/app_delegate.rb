class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    
    @calendar = CalendarViewController.alloc.init
    @window.rootViewController =  UINavigationController.alloc.initWithRootViewController @calendar
    
    @settings_button = UIBarButtonItem.alloc.initWithTitle "⚙",style: UIBarButtonItemStyleBordered, target:self, action:'show_settings'
    @calendar.navigationItem.rightBarButtonItem = @settings_button

    @kal = KalViewController.alloc.init
    @window.rootViewController.pushViewController @kal, animated: true
    
    @marked_dates = [NSDate.date]
    @kal.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle "Today", style: UIBarButtonItemStyleBordered, target: self, action: 'showAndSelectToday'
    @kal.dataSource = self

    @window.makeKeyAndVisible
    true
  end
  
  def presentingDatesFrom fromDate, to: toDate, delegate: delegate
    NSLog "from: #{fromDate}"
    @calendar_callback = delegate
    delegate.loadedDataSource self
  end
  def markedDatesFrom fromDate, to: toDate
    NSLog "Marked dates from #{fromDate} to #{toDate}"
    @marked_dates
  end
  def loadItemsFromDate fromDate, toDate: toDate # when a cell is selected
    NSLog "Load items from date #{fromDate} to #{toDate}" # 
    @marked_dates << fromDate unless @marked_dates.include? fromDate
    # @calendar_callback.loadedDataSource( self ) if @calendar_callback
  end
  def removeAllItems
  end
  def tableView tableView, cellForRowAtIndexPath: indexPath
  end
  def tableView tableView, numberOfRowsInSection: section
    0
  end
  
  def showAndSelectToday
    @kal.showAndSelectDate NSDate.date
  end
  
  def show_settings
    settings = SettingsScreen.alloc.init
    @window.rootViewController.pushViewController(settings, animated:true)
  end
end
