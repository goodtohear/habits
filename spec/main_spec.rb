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
    # habit.done?(midday + 1.day).should == false
  end

  it "picks up subchains" do
    before do 
      @habit = Habit.new
      @day = time(12,0)
      @habit.check_days [@day, @day - 3.days]
    end
    
    it "should register activity before" do
      @habit.continuesActivityBefore(@day).should == true 
    end
    it "should not register activity after" do
      @habit.continuesActivityAfter(@day).should == false
    end
    it "should now register activity after" do
      @habit.check_days [@day + 3.days]
      @habit.continuesActivityAfter(@day).should == true
    end
  end

 

end
