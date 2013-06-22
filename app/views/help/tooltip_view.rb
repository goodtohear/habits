class TooltipView < UIView
  def initWithText text, fromRect: originFrame
    if initWithFrame CGRectZero
      @text = text
      @originFrame = originFrame
      build
    end
    self
  end
  def build
    self.backgroundColor = UIColor.blackColor
    @label = UILabel.alloc.init
    @label.text = @text
    @label.font = UIFont.fontWithName("HelveticaNeue-Bold", size:14)
    @label.textColor = UIColor.whiteColor 
    @label.backgroundColor = UIColor.clearColor
    
    size = @text.sizeWithFont @label.font
    self.frame = [[@originFrame.origin.x - size.width + @originFrame.size.width * 0.5, @originFrame.origin.y + @originFrame.size.height + 5], size]

    addSubview @label
    
    edge_padding = 10
    @label.frame = [[edge_padding,5], size]
    w = size.width + 2 * edge_padding
    
    @background_layer = CAShapeLayer.layer
    @background_layer.strokeColor = UIColor.whiteColor.CGColor
    @background_layer.lineWidth = 2

    path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, 0, 0) 
    CGPathAddLineToPoint(path, nil, w - 30, 0)
    CGPathAddLineToPoint(path, nil, w - 30 + 10, -10)
    CGPathAddLineToPoint(path, nil, w - 30 + 20, 0)
    CGPathAddLineToPoint(path, nil, w, 0)
    CGPathAddLineToPoint(path, nil, w, size.height + 8) 
    CGPathAddLineToPoint(path, nil, 0, size.height + 8)
    CGPathAddLineToPoint(path, nil, 0, 0)
    @background_layer.path = path
    self.layer.insertSublayer @background_layer, atIndex: 0
    # CGPathRelease path

    @background_layer.shadowColor = UIColor.blackColor.CGColor
    @background_layer.shadowOpacity = 0.3
    @background_layer.shadowRadius = 4
    @background_layer.shadowOffset = [0,2]
    @background_layer.shouldRasterize = true
  end

end