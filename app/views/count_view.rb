class CountView < UIView
  
  RADIUS = 14
  TEXT_PADDING = 2
  
  def initWithFrame frame
    if super 
      build
    end
    self
  end

  def label x
    result = UILabel.alloc.initWithFrame [[x,0],[frame.size.width*0.5 - TEXT_PADDING * 2, frame.size.height]]
    result.textAlignment = UITextAlignmentCenter
    result.backgroundColor = UIColor.clearColor
    result.textColor = UIColor.whiteColor
    result.font = UIFont.boldSystemFontOfSize 14
    result.adjustsFontSizeToFitWidth = true
    addSubview result
    result
  end

  def build
    @background = UIView.alloc.initWithFrame [[0,0],frame.size]
    addSubview @background
    
    @current_chain_label = label TEXT_PADDING
    @longest_chain_label = label frame.size.width*0.5 + TEXT_PADDING

    @background.backgroundColor = Colors::COBALT
    @background.layer.cornerRadius = RADIUS
    
    # add two layers: [] + O to make the right hand segment
    @square, @circle = CALayer.layer, CALayer.layer
    @square.frame = [[RADIUS, 0], [frame.size.width * 0.5 - RADIUS, frame.size.height]]
    @circle.frame = [[0, 0], [frame.size.width * 0.5, frame.size.height]]
    @circle.cornerRadius = RADIUS
    
    [@square,@circle].each {|l| @background.layer.addSublayer l }

  end
  def total_color= value
    [@square,@circle].each {|l| l.backgroundColor = value.CGColor }
  end
  def text= value
    current, longest = *value
    @current_chain_label.text = "#{current}"
    @longest_chain_label.text = "#{longest}"
  end

end