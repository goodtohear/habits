class Notifications
  def self.reschedule!
    start_time = Time.now
    UIApplication.sharedApplication.scheduledLocalNotifications = Habit.active.map(&:notifications).flatten
    NSLog "Scheduled #{UIApplication.sharedApplication.scheduledLocalNotifications.count} notifications in #{Time.now - start_time}s"
  end
end