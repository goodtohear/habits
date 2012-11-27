class Notifications
  def self.reschedule!
    now = Time.now
    UIApplication.sharedApplication.setApplicationIconBadgeNumber Habit.active.select{|h| h.due?(now) and !h.done?(now) }.count
    start_time = Time.now
    notifications = Habit.active.map(&:notification).compact
    for notification in notifications
      UIApplication.sharedApplication.scheduleLocalNotification notification
    end
    
    NSLog "Scheduled #{UIApplication.sharedApplication.scheduledLocalNotifications.count} notifications in #{Time.now - start_time}s (sent #{notifications.count})"
  end
end