class Shadow
  def self.addTo view
    view.layer.shadowColor = UIColor.blackColor.CGColor
    view.layer.shadowOpacity = 0.3
    view.layer.shadowRadius = 4
    view.layer.shadowOffset = [0,2]
  end
  
end