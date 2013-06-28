# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class InformationScreen < UIViewController
  PAGES = (1..18).map{|n| "guide_#{n}"}
  
  ASSET_HEIGHT = 460.0
  def init
    if super
      build
    end
    self
  end
  
  def build
    self.view.backgroundColor = UIColor.blackColor
    navigationItem.title = "INFO"
    # @info = UIImageView.alloc.initWithImage UIImage.imageNamed "information"
    # view.addSubview @info
    
    @gallery = SwipeView.alloc.initWithFrame [[0,0],view.frame.size]
    @gallery.dataSource = self
    @gallery.delegate = self
    
    @gallery.itemSize = @gallery.frame.size
    @gallery.alignment = 1 # SwipeViewAlignment.SwipeViewAlignmentCenter
    @gallery.pagingEnabled = true
    @gallery.itemsPerPage = 1

    view.addSubview @gallery
    
    @paging = UIPageControl.alloc.initWithFrame [[0,view.frame.size.height - INSET], [320,30]]
    @paging.numberOfPages = PAGES.count
    @paging.when(UIControlEventValueChanged) do
      @gallery.scrollToPage @paging.currentPage, duration: 0.3
    end

    view.addSubview @paging
    
    w = 100
    @done = Button.create [[320-w,7],[w,30]], title: "Close ╳", color: UIColor.blackColor
    @done.when(UIControlEventTouchUpInside) do
      App::Persistence['guide_page'] = @paging.currentPage
      dismissViewControllerAnimated true, completion: ->(){}
    end
    view.addSubview @done
    
    
    [@done].each do |button|
      button.label.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 16
    end
    
    @debug_tap = UITapGestureRecognizer.alloc.initWithTarget self, action: 'reveal_debug_info'
    @debug_tap.numberOfTouchesRequired = Device.simulator? ? 2 : 3
    view.addGestureRecognizer @debug_tap

    if App::Persistence['guide_page']
      @gallery.scrollToPage App::Persistence['guide_page'], duration: 0
    end
    
    
  end

  def reveal_debug_info
    @debugger = Debugger.alloc.initWithFrame [[0,30],[320,420]]
    view.addSubview @debugger

    @reset_button = Button.create [[0,400], [320,44]], {title: "Reset info content", color: Colors::RED } 
    @reset_button.when(UIControlEventTouchUpInside) do
      InfoTask.reset_all!
    end
    view.addSubview(@reset_button)

  end
  
  def numberOfItemsInSwipeView swipeView
    PAGES.count
  end
  INSET = 44
  PAGE_INSET = 44
  def swipeView swipeView, viewForItemAtIndex: index, reusingView: view # watch out for the scope of view here
    unless view
      view = UIImageView.alloc.initWithFrame CGRectInset(@gallery.frame, 0, PAGE_INSET)
      view.contentMode = UIViewContentModeScaleAspectFit
      Shadow.addTo view
    end
    view.image = UIImage.imageNamed PAGES[index]
    view
  end
  def swipeViewCurrentItemIndexDidChange swipeView
    @paging.currentPage = swipeView.currentPage
  end
  def swipeViewItemSize swipeView
    self.view.frame.size
  end
  
  # def swipeView swipeView, didSelectItemAtIndex: index
  #   PAGES.times do |i|
  #     
  #   end
  # end

end