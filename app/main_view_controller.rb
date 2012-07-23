class MainViewController < UIViewController
  def init
    if super
      build
    end
    self
  end
  
  def build
    self.view.autoresizesSubviews = false
    @calendar = CalendarViewController.alloc.init
    @calendar.view.frame = [[0,0], [320,276]]
    view.addSubview @calendar.view
    
    
    @selector = SwipeSelectionViewController.alloc.init
    view.addSubview @selector.view
  end
  
  #swiper delegate
  def swipeSelector selector, viewAtIndexWasFocused: index
    
  end
  #swiper datasource
  def swipeSelector selector, viewForIndex: index
    
  end
  def swipeSelectorItemCount selector
    
  end
  
  # calendar delegate
  def calendar calendar, configureView: view, forDay: day
    
  end
  def calendar calendar, didChangeSelectionRange: range
    
  end
  
  
end