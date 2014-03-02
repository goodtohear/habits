class InfoOverviewScreen < UITableViewController
  
  def init
    if super
      build
    end
    self
  end

  def build
    view.backgroundColor = UIColor.whiteColor
    self.tableView.showsVerticalScrollIndicator = false
    
    self.tableView.contentInset = [0,0,0,0]

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem UIBarButtonSystemItemDone, target: self, action: 'dismiss'
    self.navigationItem.title = "GOOD TO HEAR"

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
  def links
    @links ||= [
      {text: "Log an issue", url: "https://github.com/goodtohear/habits/issues" },
      {text: "Contact us", url: "http://goodtohear.co.uk/contact"}
    ]
  end
  def credits
    @credits ||= [
      {text: "Michael Forrest (Design/Build)", url: "http://facebook.com/forrestmichael"},
      {text: "Ulrich Atz (Design)", url: "http://ulrichatz.com?from=goodhabitsapp"}
    ]
  end

  def numberOfSectionsInTableView(tableView)
    3
  end
  SECTION_HEADINGS = [
    "",
    "You can also",
    "Credits"
  ]
  def tableView(tableView, numberOfRowsInSection:section)
    case section
      when 0
       return tasks.count
      when 1
       return links.count
      when 2
       return credits.count
    end
  end

  def tableView(tableView, viewForHeaderInSection:section)
    if section == 0
      return @navbar ||= build_navbar
    end
    return InactiveHabitsHeader.alloc.initWithTitle( SECTION_HEADINGS[section])
  end

  def tableView(tableView, heightForHeaderInSection:section)
    return 30 if section == 0
    return 20
  end

  CELLID = "InfoCell"
  LINK_CELL_ID = "LinkCell"
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    if indexPath.section == 0
      cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || InfoCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      return configureCell cell, forIndexPath: indexPath
    end
    cell = tableView.dequeueReusableCellWithIdentifier(LINK_CELL_ID) || LinkCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: LINK_CELL_ID)
    link = indexPath.section == 1 ? links[indexPath.row] : credits[indexPath.row]
    cell.link = link
    return cell
   
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
      tableView.cellForRowAtIndexPath(indexPath).mark_read
    else
      things = indexPath.section == 1 ? links : credits
      App.open_url things[indexPath.row][:url]
    end
    

  end

  def build_navbar
    navbar = UIView.alloc.initWithFrame [[0,0],[320,30]]
    navbar.backgroundColor = Colors::INFO_YELLOW
    navbar.setUserInteractionEnabled(true)
    
    subheading = Labels.subheadingLabelWithFrame [[10,0],[300,30]]
    subheading.numberOfLines = 2
    subheading.font = subheading.font.fontWithSize(15)
    subheading.textColor = Colors::DARK
    subheading.text = "Hello! We hope you'd like to:"
    navbar.addSubview subheading
    navbar
  end
  def dismiss
    dismissViewControllerAnimated true, completion: ->(){}
  end
end
