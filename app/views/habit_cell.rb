class HabitCell < UITableViewCell
  attr_accessor :habit, :now
  def initWithStyle style, reuseIdentifier: identifier
    if super
      build
    end
    self
  end
  
  def build
    @backgroundColorView = UIView.alloc.init
    # setSelectedBackgroundView @backgroundColorView
    self.selectionStyle = UITableViewCellSelectionStyleNone
    @input = UITextField.alloc.initWithFrame [[50,8],[210,30]]
    @input.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 20
    @input.userInteractionEnabled = false
    @input.delegate = self
    addSubview @input
    
    @count = CountView.alloc.initWithFrame [[260,12],[30, 20]]
    @count.text = "THIS IS TEXT"
    addSubview @count

    @checkbox = CheckBox.alloc.initWithFrame [[0,0], [44,44]]
    addSubview @checkbox
    @checkbox.when_tapped do
      @habit.toggle @now
      self.habit = @habit # force update
    end    
  end

  def set_color color
    @checkbox.set_color color
    # @backgroundColorView.backgroundColor = color
  end  

  def habit= value
    @habit = value
    @input.alpha = @habit.active ? 1.0 : 0.5
    @checkbox.set_checked @habit.done? @now
    @input.text = @habit.title
    @input.textColor = @habit.overdue?(Time.now) ? '#C1272D'.to_color : UIColor.blackColor
    
    count = @habit.currentChainLength
    @count.text = count.to_s
    @backgroundColorView.backgroundColor = @habit.color
  end


end