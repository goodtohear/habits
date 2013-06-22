class ScrollEasterEggView < UIView
  def initWithFrame frame
    if super
      build
    end
    self
  end
  def build
    self.backgroundColor = "#353f4c".to_color
    @icon = UIImageView.alloc.initWithImage UIImage.imageNamed('happiness_shape.png')
    addSubview @icon
    @icon.frame = [
      [
        0.5 * (320 - @icon.frame.size.width),
        frame.size.height - 80
      ], 
      @icon.frame.size
    ]
  end
  def scrolledTo offset
    amount = (offset / 112.0)
    @icon.layer.transform = CATransform3DMakeScale(amount, amount, 1.0)
  end
end