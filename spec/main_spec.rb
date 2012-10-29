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
    habit = Habit.new time_to_do: 6, deadline: 12
    midday = time(12, 0)
    habit.check_days [midday]
    habit.done?(midday).should == true
    habit.done?(midday + 1.day).should == false
    
    
  end
  
  it "should say an active task with a deadline at 11pm is overdue at 11:30pm" do
    habit = Habit.new time_to_do: 20, deadline: 23, active: true
    habit.overdue?(time 23, 30).should == true
  end
  it "should not say that an active task due at midnight is overdue at midday" do
    habit = Habit.new time_to_do: 0, deadline: 2, active: true
    habit.overdue?(time 12).should.not == true
  end
  it "should NOT mark any 'done' tasks against the previous day if it's before the dateline hour" do
    habit = Habit.new time_to_do: 12, deadline: 14, active: true
    today = time(12, 0) # midnight today
    habit.check_days [today] 
    habit.done?(time 13).should == true
    habit.done?(time 1).should == true
  end
  
end
