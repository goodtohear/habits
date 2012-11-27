# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
describe "Application 'habits'" do
  before do
    @app = UIApplication.sharedApplication
  end

  it "has one window" do
    @app.windows.size.should == 1
  end
  
  def time(hour,minute=0)
    Time.local 2012, 06, 12, hour, minute
  end
  
  it "gets normal habits 'done' right" do
    habit = Habit.new time_to_do: 6, deadline: 12, active: true
    midday = time(12, 0)
    habit.check_days [midday]
    habit.done?(midday).should == true
    habit.done?(midday + 1.day).should == false
  end
  
  it "should calculate today's first reminder only if reminder time is in the past" do
    now = Time.now
    past = now - 2.hours
    future = now + 2.hours
    habit = Habit.new time_to_do: past.hour, deadline: future.hour, active: true
    habit.calculate_notifications_for_today(now)
    habit.notifications.count.should == 1
  end

  it "should calculate both reminders if they are both in the future" do
    now = Time.now
    to_do = now + 2.hours
    deadline = now + 4.hours
    habit = Habit.new time_to_do: to_do.hour, deadline: deadline.hour, active: true
    habit.calculate_notifications_for_today(now)
    habit.notifications.count.should == 2
    
  end
  
  it "should calculate neither of today's reminders if they are both in the past" do
    now = Time.now
    to_do = now - 4.hours
    deadline = now - 2.hours
    habit = Habit.new time_to_do: to_do.hour, deadline: deadline.hour, active: true, label: "both in past"
    habit.calculate_notifications_for_today(now)
    habit.notifications.count.should == 0
    
  end
  
  it "should only calculate reminders for active habits" do
    habit = Habit.new time_to_do: 12, deadline: 18
    habit.active.should == false
    habit.calculate_notifications_for_today time(16)
    habit.notifications.count.should == 0

  end
  
  it "should set midnight reminders for the next day if to_do is before midnight and deadline is midnight" do
    now = time(18,00)
    to_do = 12
    deadline = 0
    habit = Habit.new time_to_do: to_do, deadline: deadline, title: "midnight reminders", active: true
    habit.calculate_notifications_for_today(now)
    habit.notifications.count.should == 1
    habit.notifications.first.fireDate.should > now
  end
  
  it "should not set reminders for today if to_do is midnight" do
    now = time(18,00)
    to_do = 0
    deadline = 3
    habit = Habit.new time_to_do: to_do, deadline: deadline, title: "early reminders", active: true
    habit.calculate_notifications_for_today(now)
    habit.notifications.count.should == 0
  end
  

end
