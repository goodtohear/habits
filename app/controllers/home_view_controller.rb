class HomeViewController < UIViewController
  attr_reader :list
  def init
    if super
      build
    end
    self
  end
  def build
    
    @list = HabitListViewController.alloc.init
    @list.view.frame = [[0, 44],[self.view.bounds.size.width, self.view.bounds.size.height - 44]]
    view.addSubview(@list.view)
    
    @navbar = UIImageView.alloc.initWithImage UIImage.imageNamed("nav")
    self.view.addSubview(@navbar)

    add_title
    @info_button = BarImageButton.normalButtonWithImageNamed('info')
    @info_button.accessibilityLabel = "Information"
    @info_button.when(UIControlEventTouchUpInside) do
      self.showInfo
    end
    @info_button.frame = [[0,0], [44,44]]
    self.view.addSubview @info_button
    
    @add_button = BarImageButton.normalButtonWithImageNamed('add')
    @add_button.accessibilityLabel = "Add new habit"
    @add_button.when(UIControlEventTouchUpInside) do
      self.addItem
    end
    # navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithCustomView @add_button
    @add_button.frame = [[self.view.frame.size.width - 44, 0], [44,44]]
    self.view.addSubview @add_button
    
  end
  def add_title
    @title_label = UILabel.alloc.initWithFrame [[0,0],[320,44]]
    @title_label.text = "GOOD HABITS"
    @title_label.backgroundColor = UIColor.clearColor
    @title_label.textAlignment = UITextAlignmentCenter
    @title_label.textColor = UIColor.whiteColor
    @title_label.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    view.addSubview @title_label
  end
  def showInfo
    presentViewController InfoOverviewScreen.alloc.init, animated: true, completion: ->(){}
  end
  def addItem
    @list.addItem
  end
  def reload
    @list.tableView.reloadData
  end
  def viewWillAppear animated
    @list.refresh()
  end
  
end