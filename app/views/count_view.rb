# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class CountView < UIView
  
  RADIUS = 14
  TEXT_PADDING = 2
  
  def initWithFrame frame
    if super 
      build
    end
    self
  end

  def isAccessibilityElement
    true
  end
  def accessibilityLabel
    "Current chain length #{@current_chain_label.text}, longest chain #{@longest_chain_label.text}"
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
    
    halfway = frame.size.width * 0.5
    # add two layers: [] + O to make the right hand segment
    @square, @circle = CALayer.layer, CALayer.layer
    @square.frame = [[RADIUS, 0], [halfway - RADIUS, frame.size.height]]
    @circle.frame = [[0, 0], [halfway, frame.size.height]]
    @circle.cornerRadius = RADIUS
    
    @gap = CALayer.layer
    @gap.backgroundColor = UIColor.whiteColor.CGColor
    @gap.frame = [[halfway - 1, 0], [2,frame.size.height] ]
    
    [@square, @circle, @gap].each{|l| @background.layer.addSublayer l }

  end
  
  def highlighted= highlighted
    return if @color.nil?
    CATransaction.begin
    CATransaction.setDisableActions true
    color = highlighted ? UIColor.whiteColor : @color
    [@square,@circle].each {|l| l.backgroundColor = color.CGColor }
    @background.backgroundColor = highlighted ? UIColor.whiteColor : (@is_happy ? @color : Colors::COBALT)  # dup
    [@current_chain_label, @longest_chain_label].each do |label|
      label.textColor = highlighted ? @color : UIColor.whiteColor # dup
    end
    @gap.backgroundColor = highlighted ? @color.CGColor : UIColor.whiteColor.CGColor # dup
    CATransaction.commit
  end
  def is_happy= value
    @is_happy = value
  end
  def total_color= value
    @color = value
    [@square, @circle].each{|l| l.backgroundColor = value.CGColor }
  end
  def text= value
    current, longest = *value
    @current_chain_label.text = "#{current}"
    @longest_chain_label.text = "#{longest}"
  end

end