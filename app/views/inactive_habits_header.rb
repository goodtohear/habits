class InactiveHabitsHeader < UIView

  def init
    if super
      build
    end
    self
  end
  
  def build
    self.backgroundColor = '#5D5D5D'.to_color
    @textLabel = UILabel.alloc.initWithFrame [[10,0],[300,44]]
    @textLabel.backgroundColor = UIColor.clearColor
    @textLabel.textColor = UIColor.whiteColor
    @textLabel.textAlignment = UITextAlignmentCenter
    @textLabel.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    self.backgroundColor = '#999'.to_color
    addSubview @textLabel
    
    @textLabel.text = "Inactive habits"
  end
  
end