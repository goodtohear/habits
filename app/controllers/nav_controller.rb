class NavController < UINavigationController
  def viewWillAppear animated
    super
    self.restorationIdentifier = "Nav"

    self.navigationBar.barTintColor = Colors::DARK
    self.navigationBar.translucent = true
  end
  def viewDidAppear animated
    super 
  end
end
