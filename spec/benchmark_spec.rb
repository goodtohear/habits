# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
describe  "Application performance" do
  before do
    @app = UIApplication.sharedApplication
  end
  it "should calculate month chains quickly enough." do
    start_time = Time.now
    habit = Habit.new
    50.times do |t|
      habit.check_days [Time.now - t.days]
    end
    day = Time.now - 30.days
    1000.times do 
      MonthGridViewController.cellStateForHabit habit, date: day
    end
    end_time = Time.now
    NSLog "TIME: #{end_time - start_time}"
    (end_time - start_time).should <= 0.3 # actually not fast.

  end
end