# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class HabitCell < UITableViewCell
  attr_accessor :habit, :now
  def initWithStyle style, reuseIdentifier: identifier
    if super
      build
    end
    self
  end
  
  def build
    self.backgroundColor = UIColor.whiteColor
    @backgroundColorView = UIView.alloc.initWithFrame [[0,0],self.frame.size]
    @backgroundColorView.backgroundColor = '#d6cdbf'.to_color
    @backgroundColorView.hidden = true
    addSubview @backgroundColorView
    self.selectionStyle = UITableViewCellSelectionStyleNone
    
    @input = UITextField.alloc.initWithFrame [[42,8],[194,30]]
    @input.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 20
    @input.userInteractionEnabled = false
    @input.delegate = self
    addSubview @input
                                            # y = 10 because the check box starts at 10. yes. not idea.
    @count = CountView.alloc.initWithFrame [[240,8],[70, 28]]
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
    @color = color
    @checkbox.set_color color
    @count.total_color = color
    @backgroundColorView.backgroundColor = color
  end  

  def setHighlighted selected, animated: animated
    super
    @backgroundColorView.hidden = !selected
    @input.textColor = selected ? UIColor.whiteColor : textColor
    @count.highlighted = selected
  end
  
  # def touchesBegan touches, withEvent: event
  #   @input.textColor = UIColor.whiteColor
  # end
  # def touchesEnded touches, withEvent: event
  #   @input.textColor = UIColor.blackColor
  # end
  def textColor
    (@habit.due?(Time.now) and !@habit.done?(Time.now)) ? '#C1272D'.to_color : UIColor.blackColor
  end
  def habit= value
    @habit = value
    @input.alpha = @habit.active ? 1.0 : 0.5
    @checkbox.set_checked @habit.done? @now
    @checkbox.label = @habit.title
  
    @input.text = @habit.title
    @input.textColor = textColor
    
    count = @habit.currentChainLength
    
    @count.text = [count.to_s, @habit.longestChain]
    
    
    # @backgroundColorView.backgroundColor = @habit.color
  end


end