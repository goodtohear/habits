class InfoOverviewScreen < UITableViewController
  
  def init
    if super
      build
    end
    self
  end

  def build
    view.backgroundColor = UIColor.whiteColor
    
    # @how_to_use = Button.create [[30,30],[260,40]], title: "How to use", color: UIColor.blackColor
    # @how_to_use.when(UIControlEventTouchUpInside) do
    #   presentViewController InformationScreen.alloc.init, animated: true, completion: ->(){}
    # end
    # view.addSubview @how_to_use

  # ow, pasted. could avoid with some different inheritance pattern.
  @easter_egg = ScrollEasterEggView.alloc.initWithFrame [[0,-200],[320,200]]
    self.view.addSubview @easter_egg

  end
  def scrollViewDidScroll scrollView
    return if !@easter_egg 
    offset = -scrollView.contentOffset.y
    return if offset < 0 
    @easter_egg.scrolledTo offset
  end

  def tasks
    @tasks ||= InfoTask.due
  end

  def numberOfSectionsInTableView(tableView)
    2
  end

  def tableView(tableView, numberOfRowsInSection:section)
    if section == 0
      return tasks.count
    end
    return 0
  end

  def tableView(tableView, viewForHeaderInSection:section)
    if section == 0
      return @navbar ||= build_navbar
    end
    return @secondary_header ||= InactiveHabitsHeader.alloc.initWithTitle( "You can also")
  end

  def tableView(tableView, heightForHeaderInSection:section)
    return 55 if section == 0
    return 20
  end

  CELLID = "InfoCell"

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || InfoCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
    configureCell cell, forIndexPath: indexPath
  end

  def configureCell cell, forIndexPath: indexPath
    cell.task = tasks[indexPath.row]
    cell.set_color tasks[indexPath.row].color
    cell.controller = self
    cell
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    if indexPath.section == 0
      tasks[indexPath.row].open(self)
    end
  end

  def build_navbar
    navbar = UIImageView.alloc.initWithImage UIImage.imageNamed("nav")
    navbar.setUserInteractionEnabled(true)
    titleLabel = Labels.navbarLabelWithFrame([[0,0],[320,44]])

    titleLabel.text = "GOOD TO HEAR"
    navbar.addSubview(titleLabel)
    
    done = UIButton.alloc.initWithFrame [[320 - 60,1],[60,44]]
    done.setTitle("DONE", forState:UIControlStateNormal)
    done.titleLabel.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 16
    done.when(UIControlEventTouchUpInside) do
      dismissViewControllerAnimated true, completion: ->(){}
    end
    navbar.addSubview done
    navbar
  end
end