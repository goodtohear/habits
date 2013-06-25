class Notifications
  def self.reschedule!
    now = Time.now
    UIApplication.sharedApplication.setApplicationIconBadgeNumber Habit.active.select{|h| h.needs_to_be_done?(now) }.count
    start_time = Time.now
    notifications = Habit.active.map(&:notifications).flatten.compact
    Debugger.buffer << "Attempting to schedule #{notifications.count} notification(s)"
    UIApplication.sharedApplication.cancelAllLocalNotifications
    for notification in notifications
      UIApplication.sharedApplication.scheduleLocalNotification notification
    end
    Debugger.buffer << "Rescheduled at #{Time.now} in #{Time.now - start_time}s"
    # NSLog "Scheduled #{UIApplication.sharedApplication.scheduledLocalNotifications.count} notifications in #{Time.now - start_time}s (sent #{notifications.count})"

    # Schedule some badge numbers for the mornings (6am)
    # notification.applicationIconBadgeNumber = 1
    for n in (1..7)
      day = TimeHelper.addDays n, toDate: now
      notification = UILocalNotification.alloc.init
      notification.fireDate = Time.local day.year, day.month, day.day, 6, 0
      notification.applicationIconBadgeNumber = Habit.habitCountForDate day
      UIApplication.sharedApplication.scheduleLocalNotification notification
    end


  end
end