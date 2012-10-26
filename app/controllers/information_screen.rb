class InformationScreen < UIViewController
  PAGES = [ 
      'home_screen', 'detail_screen'
    ]
  
  ASSET_HEIGHT = 460
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
    @gallery.alignment = SwipeViewAlignmentCenter
    @gallery.pagingEnabled = true
    @gallery.itemsPerPage = 1

    view.addSubview @gallery
    
    @paging = UIPageControl.alloc.initWithFrame [[0,ASSET_HEIGHT - INSET], [320,30]]
    @paging.numberOfPages = PAGES.count
    view.addSubview @paging
    
    w = 80
    @done = Button.create [[300-w,7],[w,30]], title: "Close", color: Colors::COBALT 
    @done.when(UIControlEventTouchUpInside) do
      dismissViewControllerAnimated true, completion: ->(){}
    end
    view.addSubview @done
    
  end
  
  def numberOfItemsInSwipeView swipeView
    PAGES.count
  end
  INSET = 44
  def swipeView swipeView, viewForItemAtIndex: index, reusingView: view # watch out for the scope of view here
    unless view
      view = UIImageView.alloc.initWithFrame [[INSET,INSET], [320 - INSET * 2, ASSET_HEIGHT - INSET * 2]] # 460 reflects the asset size, not the screen size
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