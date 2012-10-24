class InactiveOverlayView < UIView
  attr_reader :delete, :activate
  def initWithFrame frame
    if super
      build()
    end
    self
  end
  
  
  def build
    @overlay = UIView.alloc.initWithFrame [[0,0],self.frame.size]
    addSubview @overlay
    @overlay.backgroundColor = UIColor.blackColor
    @overlay.alpha = 0.8
    
    next_y = 60
    @title = UILabel.alloc.initWithFrame [[10,next_y], [300,40]]
    @title.backgroundColor = UIColor.clearColor
    @title.text = "Habit is currently inactive"
    @title.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    @title.textAlignment = UITextAlignmentCenter
    @title.textColor = UIColor.whiteColor
    addSubview @title


    next_y += 50
    @activate = UIButton.buttonWithType UIButtonTypeRoundedRect
    @activate.setTitle "Activate", forState: UIControlStateNormal
    @activate.frame = [[10,next_y], [300,44]]
    addSubview @activate

    next_y += 70    
    @delete = UIButton.buttonWithType UIButtonTypeRoundedRect
    @delete.setTitle "Delete Permanently", forState: UIControlStateNormal
    @delete.tintColor = '#C1272D'.to_color
    @delete.frame = [[10,next_y], [300,44]]
    addSubview @delete
  end
  
  def toggleActive active, animated
    t = animated ? 0.4 : 0
    UIView.animateWithDuration t, animations: ->{
      self.alpha = active ? 0 : 1.0
    }, completion: ->(complete){
      self.userInteractionEnabled = !active
    }
  end
  
end