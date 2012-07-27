class AddView < UIView
  def initWithFrame frame
    if super
      build
    end
    self
  end
  
  def build
    @plus_sign = UIImageView.alloc.initWithImage UIImage.imageNamed "add"
    @plus_sign.frame = [[280,8],@plus_sign.frame.size]
    addSubview @plus_sign
    
    @instruction = UILabel.alloc.initWithFrame [[10,4], [200,30]]
    @instruction.font = UIFont.fontWithName "Helvetica-Bold", size: 20
    @instruction.textColor = '#8A95A1'.to_color
    addSubview @instruction
    
    self.cocked = false
    @plus_sign.transform = CGAffineTransformMakeRotation(-Math::PI / 4)
  end
  
  def cocked
    @cocked
  end
  def cocked= value
    @cocked = value
    @instruction.text = @cocked ? "Release to add" : "Pull to add new"
    UIView.animateWithDuration 0.2, animations: -> do
      @plus_sign.transform = @cocked ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(-Math::PI / 4)
      @instruction.alpha = @plus_sign.alpha = @cocked ? 1.0 : 0.5
    end
  end
  
end