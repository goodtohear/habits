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
    @scroller.showsHorizontalScrollIndicator = false
    @scroller.delegate = self
    view.addSubview @scroller
    
    
    @add = AddView.alloc.initWithFrame [[-320,0], [320,145]]
    @scroller.addSubview @add
    
  end
  
  def reloadData
    refreshViews
    for index in (0..@dataSource.swipeSelectorItemCount(self)-1)
      pane = @dataSource.swipeSelector self, viewForIndex: index
      pane.frame = [[index * 320, 0], view.frame.size]
      @scroller.addSubview pane
    end
  end
  
  def selectedIndex
    index = (@scroller.contentOffset.x / 320).round    
  end
  
  # scrollView delegate
  def scrollViewDidEndDecelerating scrollView
    refreshViews
  end

  def scrollViewDidEndDragging scrollView, willDecelerate: willDecelerate
    delegate.swipeSelector self, viewWasFocusedAtIndex: selectedIndex
    
    if @add.cocked
      delegate.swipeSelector self, addItemAtIndex: 0
    end
  end
  
  def scrollViewDidScroll scrollView
    if @add.cocked and scrollView.contentOffset[0] > -50
      @add.cocked = false
    end
    if scrollView.contentOffset[0] < -50 and !@add.cocked
      @add.cocked = true
    end
    
  end
  
  # swipiness
  def refreshViews
    index = selectedIndex
    pane = @dataSource.swipeSelector self, viewForIndex: index
    
    @scroller.contentSize = [320 * Habit.all.count, 145]
    
    pane.frame = [[index * 320, 0], view.frame.size]
    

    @pips.currentPage = index
    @pips.numberOfPages = @dataSource.swipeSelectorItemCount(self)
    size = @pips.sizeForNumberOfPages(@pips.numberOfPages)
    @pips.frame = [[ 0.5 * (320 - size[0]), 136], size]
  end
  
  #
  def addPips
    
    @pips = DDPageControl.alloc.initWithType DDPageControlTypeOnFullOffEmpty
    @pips.userInteractionEnabled = false
    @pips.indicatorDiameter = 6
    @pips.onColor = '#8A95A1'.to_color
    @pips.offColor = '#8A95A1'.to_color
    view.addSubview @pips

  end
  
end