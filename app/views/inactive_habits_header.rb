# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class InactiveHabitsHeader < UIView

  def init
    if super
      build
    end
    self
  end
  
  def build
    self.backgroundColor = Colors::COBALT
    @textLabel = UILabel.alloc.initWithFrame [[10,0],[300,44]]
    @textLabel.backgroundColor = UIColor.clearColor
    @textLabel.textColor = UIColor.whiteColor
    @textLabel.textAlignment = UITextAlignmentCenter
    @textLabel.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    addSubview @textLabel
    
    @textLabel.text = "Paused habits"
  end
  
end