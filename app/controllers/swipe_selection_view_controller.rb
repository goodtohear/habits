class SwipeSelectionViewController < UIViewController
  
  # RESPONSIBILITIES:
  # Showing current selection
  # Updating selection
  # Triggering new items to be added
  
  attr_accessor :delegate
  attr_accessor :dataSource
  
  def init
    if super
      @panes= []
    end
    self
  end
  def viewDidLoad
    view.autoresizesSubviews = false
    build
  end
  
  def build
    addPips
    
    @scroller = UIScrollView.alloc.initWithFrame [[0,0], [320,145]]
    @scroller.pagingEnabled = true
    @scroller.delegate = self
    view.addSubview @scroller
    @scroller.contentSize = [320 * Habit.all.count, 145]

  end
  
  def reloadData
    refreshViews
  end
  
  def selectedIndex
    index = (@scroller.contentOffset.x / 320).round    
  end
  
  # scrollView delegate
  def scrollViewDidEndDecelerating scrollView
  end

  def scrollViewDidEndDragging scrollView, willDecelerate: willDecelerate
    delegate.swipeSelector self, viewWasFocusedAtIndex: selectedIndex
    refreshViews
  end
  
  # swipiness
  def refreshViews
    index = selectedIndex
    pane = @dataSource.swipeSelector self, viewForIndex: index
    pane.frame = [[index * 320, 0], view.frame.size]
    @scroller.addSubview pane


    @pips.currentPage = 1
    @pips.numberOfPages = @dataSource.swipeSelectorItemCount(self)
    size = @pips.sizeForNumberOfPages(@pips.numberOfPages)
    @pips.frame = [[ 0.5 * (320 - size[0]), 136], size]
  end
  
  #
  def addPips
    @pips = DDPageControl.alloc.initWithType DDPageControlTypeOnFullOffEmpty
    @pips.indicatorDiameter = 8
    @pips.onColor = '#8A95A1'.to_color
    @pips.offColor = '#8A95A1'.to_color
    view.addSubview @pips

  end
  
end