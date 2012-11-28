class Debugger < UITextView
  # I'm gonna keep debug info here statically. Sue me.
  class << self
    attr_accessor :buffer
    
  end
  @buffer = []
  
  def initWithFrame frame
     if super
       build()
     end
     self
   end
   def build
     self.backgroundColor = UIColor.blackColor
     self.textColor = UIColor.whiteColor
     notifications = Habit.active.map(&:notification)
     debug_info = "Debug information (three finger tap to reveal)\n"
     debug_info += "#{notifications.count} notification(s) scheduled\n"
     debug_info += Debugger.buffer.join("\n")
     debug_info += "\n\n"
     for n in notifications
       debug_info += "#{n.fireDate}, every #{n.repeatInterval}: #{n.alertBody}\n" unless n.nil?
     end
     self.text = debug_info
   end
end