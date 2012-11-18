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
    habit = Habit.new time_to_do: 6, deadline: 12
    midday = time(12, 0)
    habit.check_days [midday]
    habit.done?(midday).should == true
    habit.done?(midday + 1.day).should == false
    
    
  end
  

end
