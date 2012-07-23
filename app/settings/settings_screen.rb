class SettingsScreen < UITableViewController
  def tableView tableView, numberOfRowsInSection: section
    5
  end

  CELLID = 'CellIdentifier'
  def tableView tableView, cellForRowAtIndexPath: indexPath
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
      cell
    end
    cell.textLabel.text = "HELLO"
    cell
  end
end