class DragToAddTableView < UITableView
  attr_accessor :tableViewDelegate
  def initWithFrame frame
    if super
      build
    end
    self
  end
  
  def layoutSubviews
    super
    @add.frame = [[0,-44], [320,44]]
  end
  
  def build
    self.delegate = self
    @add = AddView.alloc.initWithFrame [[0,-44], [320,44]]
    addSubview @add
  end
  # swiper table scroll delegate
  def scrollViewDidEndDragging scrollView, willDecelerate: willDecelerate
    if @add.cocked
      # delegate.swipeSelector self, addItemAtIndex: 0
      tableViewDelegate.tableViewInsertNewRow self
    end
  end
  
  def scrollViewDidScroll scrollView
    if @add.cocked and scrollView.contentOffset[1] > -44
      @add.cocked = false
    end
    if scrollView.contentOffset[1] < -44 and !@add.cocked
      @add.cocked = true
    end
    
  end

  def tableView tableView, didSelectRowAtIndexPath:indexPath
    tableViewDelegate.tableView tableView, didSelectRowAtIndexPath: indexPath
  end
  
  def tableView(tableView, commitEditingStyle:editing_style, forRowAtIndexPath:indexPath)
    tableViewDelegate.tableView tableView, commitEditingStyle: editing_style, forRowAtIndexPath: indexPath
  end
end