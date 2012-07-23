class NavButton < UIView
  def initWithFrame(rect)
    if super
      self.frame = rect
      @label = HeaderLabel.alloc.initWithFrame [[0,0], rect[1]]
      point :left
      self.addSubview @label
    end
    self
  end
  def point direction=:left
    @label.text = direction == :left ? "◂" : "▸"
  end
end