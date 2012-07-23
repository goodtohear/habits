class AddView < UIView
  def initWithFrame frame
    if super
      build
    end
    self
  end
  
  def build
    @plus_sign = UIImageView.alloc.initWithImage UIImage.imageNamed "add"
    @plus_sign.frame = [[260,64-20],@plus_sign.frame.size]
    addSubview @plus_sign
    @instruction = UILabel.alloc.initWithFrame [[260,104-20], [35,40]]
    @instruction.font = UIFont.fontWithName "Helvetica-Bold", size: 10
    @instruction.numberOfLines = 2
    @instruction.textAlignment = UITextAlignmentCenter
    @instruction.text = "release to add"
    addSubview @instruction
    
    cocked = false
    @plus_sign.transform = CGAffineTransformMakeRotation(-Math::PI / 4)
  end
  
  def cocked
    @cocked
  end
  def cocked= value
    @cocked = value
    UIView.animateWithDuration 0.2, animations: -> do
      @plus_sign.transform = @cocked ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(-Math::PI / 4)
      @instruction.alpha = @cocked ? 1.0 : 0.0
    end
  end
  
end