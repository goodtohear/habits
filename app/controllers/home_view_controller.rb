class HomeViewController < UIViewController
  attr_reader :list, :top
  def init
    if super
      build
    end
    self
  end
  def build
    self.restorationIdentifier = "Home"
    
    @list = HabitListViewController.alloc.init

    @top = 0

    @list.view.frame = [[0, top],[self.view.bounds.size.width, self.view.bounds.size.height - top ]]
    view.addSubview(@list.view)
    
    navigationItem.title = "GOOD HABITS"

    infoImageView = UIImageView.alloc.initWithImage UIImage.imageNamed('info')
    infoImageView.contentMode = UIViewContentModeLeft
    infoImageView.frame = [[0,0],[44,44]]
    @infoButtonView = UIView.alloc.initWithFrame infoImageView.frame
    @infoButtonView.addSubview infoImageView
    @info_button = BW::UIBarButtonItem.custom @infoButtonView  do 
      self.showInfo
    end
    @info_button.accessibilityLabel = "Information"
    
    navigationItem.leftBarButtonItem = @info_button
    
    @info_count_badge = InfoCountBadge.alloc.initWithFrame [[7,2],[16,16]]
    @infoButtonView.addSubview @info_count_badge

    @add_button = BW::UIBarButtonItem.styled :plain, UIImage.imageNamed('add') do
      self.addItem
    end
    @add_button.accessibilityLabel = "Add new habit"
    navigationItem.rightBarButtonItem = @add_button
    
    if Habit.all.count == 0 and !@get_started_button
      @get_started_button = TooltipView.alloc.initWithText "TAP HERE TO GET STARTED", fromRect: CGRectMake(270,-32,50,44)
      view.addSubview @get_started_button
    end

  end
  def showInfo
    infoContainer = NavController.alloc.initWithRootViewController InfoOverviewScreen.alloc.init
    presentViewController infoContainer, animated: true, completion: ->(){}
  end
  def addItem
    @list.addItem
    if @get_started_button
      UIView.animateWithDuration 0.2, animations: ->{
        @get_started_button.alpha = 0
      }
    end
  end
  def reload
    @list.tableView.reloadData
  end
  def viewWillAppear animated
    super
    self.edgesForExtendedLayout = UIRectEdgeNone
    refresh()
  end
  def refresh
    @list.refresh()
    @info_count_badge.refresh()
  end
end
