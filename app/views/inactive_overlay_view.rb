class InactiveOverlayView < UIView
  attr_reader :delete, :activate, :done
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
    @title.text = "Habit is paused"
    @title.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    @title.textAlignment = UITextAlignmentCenter
    @title.textColor = UIColor.whiteColor
    addSubview @title

    next_y += 60
    @done = Button.create [[10,next_y], [300,44]], {title: "OK", color: Colors::COBALT }
    addSubview @done


    next_y += 80
    @activate = Button.create [[10,next_y], [300,44]], {title: "Unpause", color: Colors::GREEN}
    addSubview @activate

    next_y += 80    
    @delete = Button.create [[10,next_y], [300,44]], {title: "Delete", color:'#C1272D'.to_color}
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