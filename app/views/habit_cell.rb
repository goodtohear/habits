# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class HabitCell < CellWithCheckBox
  attr_accessor :habit, :now, :inactive
  
  def build
    super 
    # y = 8 because the check box starts at 10. yes. not ideal.
    @count = CountView.alloc.initWithFrame [[240,8],[70, 28]]
    @count.text = ""
    addSubview @count

    @checkbox.when_tapped do
      @checkbox.set_checked !@checkbox.checked?
      Dispatch::Queue.concurrent.async do
        @habit.toggle @now
        Dispatch::Queue.main.async do
          self.habit = @habit # force update
        end
      end
    end    
  end

  def set_color color
    super
    @count.total_color = color
  end  

  def setHighlighted selected, animated: animated
    super
    @count.highlighted = selected
  end
  
  def textColor
    ((@habit.due?(Time.now) and !@habit.done?(Time.now)) || (!@inactive && @habit.currentChainLength == 0)) ? Colors::RED : UIColor.blackColor
  end

  def habit= value
    @habit = value
    @label.alpha = @inactive ? 0.5 : 1.0
    @checkbox.set_checked @habit.done? @now
    @checkbox.label = @habit.title
  
    @label.text = @habit.title
    @label.textColor = textColor
    current_chain_length = @habit.currentChainLength 
    longest_chain = @habit.longestChain
    @count.text = [current_chain_length.to_s, longest_chain]
    @count.is_happy = current_chain_length > 0 && current_chain_length == longest_chain
    @count.highlighted = false
    # @backgroundColorView.backgroundColor = @habit.color
  end


end
