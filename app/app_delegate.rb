# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # TestFlight.takeOff('690465ac-985d-4c16-ace3-ce09a282d29a')
    Appearance.apply()
    @window = UIWindow.alloc.initWithFrame UIScreen.mainScreen.bounds
    @window.tintColor = UIColor.whiteColor

    unless App::Persistence['installed_date']
      App::Persistence['installed_date'] = Habit.all.count > 0 ? Habit.all.map(&:earliest_date).min : Time.now
      NSLog "Earliest date set to #{App::Persistence['installed_date']}"
    end

    @main = HomeViewController.alloc.init
    @nav = NavController.alloc.initWithRootViewController @main

    @main.list.nav = @nav # (not happy about this)


    @window.rootViewController =  @nav
    #@window.backgroundColor = Colors::DARK

    @window.makeKeyAndVisible
    Habit.recalculate_all_notifications
    Notifications.reschedule!

    true
  end

  def applicationWillEnterForeground application
    @main.refresh
  end
  def applicationDidReceiveLocalNotification notification
    @main.refresh
    Habit.recalculate_all_notifications
    Notifications.reschedule!
  end
  def applicationWillResignActive application
    Habit.recalculate_all_notifications
    Notifications.reschedule!
  end
  def applicationDidBecomeActive application
    @main.reload
  end

  # state restoration:
  def application application, shouldSaveApplicationState: coder
    true
  end

  def application application, shouldRestoreApplicationState: coder
    true
  end

  # custom urls
  def application(application, openURL:url, sourceApplication:sourceApp, annotation:annotation)
    prefix, hash = * url.absoluteString.split('goodhabits://import?json=')
    if hash
      BW::UIAlertView.new({
        title: 'Restore data?',
        message: 'Restore your data? This action will delete your current data. Proceed with caution.',
        buttons: ['Cancel', 'Restore Data'],
        cancel_button_index: 0
      }) do |alert|
        unless alert.clicked_button.cancel?
          json_string = hash.unpack('m')[0]

          json = BW::JSON.parse json_string
          habits = json.map{|json| Habit.from_json json}
          Habit.replace_all_with habits
          @main.refresh
        end
      end.show

    end

  end

end
