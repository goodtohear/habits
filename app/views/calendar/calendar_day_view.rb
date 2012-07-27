class CalendarDayView < UIView
  
  FUTURE_COLOR = '#8A95A1'.to_color
  MISSED_COLOR = '#C1272D'.to_color
  ON_COLOR = UIColor.whiteColor
  BEFORE_START_COLOR = '#3A4450'.to_color
  
  
  attr_reader :label
  attr_accessor :day
  def initWithFrame(rect)
    if super
      @block = UIView.alloc.initWithFrame [[0,0], frame.size]
      addSubview @block
      @block.userInteractionEnabled = false
      
      @label = UILabel.alloc.initWithFrame [[0,0], frame.size]
      @label.font = UIFont.fontWithName "Helvetica-Bold", size: 18
      @label.backgroundColor = UIColor.clearColor
      @label.textAlignment = UITextAlignmentCenter
      @label.text = "11"
      self.addSubview @label
      setSelectionState :future, color: nil
    end
    self
  end
  
  # :first_in_chain, :last_in_chain, :mid_chain, :missed, :future, :before_start
  def setSelectionState state, color: color
    if [:first_in_chain,:last_in_chain,:mid_chain].include? state
      @label.textColor = ON_COLOR
      self.backgroundColor = color
    end
    @block.hidden = true
    layer.cornerRadius = state == :mid_chain ? 0 : 22
    
    @block.hidden = !([:last_in_chain, :first_in_chain].include? state)
    @block.frame = [[0, 0],[frame.size.width * 0.5, frame.size.height]] if state == :last_in_chain
    @block.frame = [[frame.size.width * 0.5, 0],[frame.size.width * 0.5, frame.size.height]] if state == :first_in_chain

    if [:missed, :future, :before_start].include? state
      self.backgroundColor = UIColor.whiteColor
      @label.textColor = FUTURE_COLOR
    end
    if state == :before_start
      @label.textColor = BEFORE_START_COLOR
    end
    if state == :missed
      @label.textColor = MISSED_COLOR
    end
  end
  
end