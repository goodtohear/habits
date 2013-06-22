# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class CalendarViewController < UIViewController

  attr_accessor :dataSource
  
  def viewDidLoad
    view.autoresizesSubviews = false
    view.backgroundColor = UIColor.whiteColor
    # view.layer.shadowColor = UIColor.blackColor.CGColor
    # view.layer.shadowOpacity = 0.3
    # view.layer.shadowRadius = 4
    # view.layer.shadowOffset = [0,2]
    
    @top = CalendarTopView.alloc.initWithFrame [[0,0],[320,54]]
    view.addSubview @top
    
    @top.prev_button.when(UIControlEventTouchUpInside) do
      showMonthIncludingTime @dayInPreviousMonth unless @navigation_is_disabled # if @dayInPreviousMonth
    end
    @top.next_button.when(UIControlEventTouchUpInside) do
      showMonthIncludingTime @dayInNextMonth unless @navigation_is_disabled  # if @dayInNextMonth
    end
    
    @scroller = UIScrollView.alloc.initWithFrame [[0,56], [320,220]]
    self.view.addSubview @scroller
    showMonthIncludingTime Time.now
    
  end
  
  def showMonthIncludingTime time
    month = time.month
    return if @grid and @grid.month == month
    @grid.view.removeFromSuperview if @grid and @grid.view.superview
    @grid = nil
    
    @top.label.text = time.strftime '%B %Y'
    
    firstDay = Time.local time.year, time.month
    
    @dayInPreviousMonth = firstDay - 10.days
    @dayInNextMonth = firstDay + 36.days
    
    until firstDay.sunday? do
      firstDay = TimeHelper.addDays -1, toDate: firstDay
    end
    
    @grid = MonthGridViewController.alloc.init
    @grid.firstDay = firstDay
    @grid.month = month 
    @scroller.addSubview @grid.view
    showChainsForHabit @habit if @habit
    
  end
  
  def showChainsForHabit habit
    @navigation_is_disabled = true
    @habit = habit
    @grid.showChainsForHabit habit do
      @navigation_is_disabled = false
    end
  end
  
end