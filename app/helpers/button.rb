# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class Button < UIControl
  def self.create frame, options= {title: "OK"}
    result = Button.alloc.initWithFrame frame
    result.title = options[:title] or ""
    result.color = options[:color]
    result
  end
  def initWithFrame frame
    if super
      build
    end
    self
  end
  attr_reader :label
  def build
    layer.cornerRadius = self.frame.size.height * 0.5
    
    @label = UILabel.alloc.initWithFrame [[10,0], [self.frame.size.width - 20,self.frame.size.height]]
    @label.textAlignment = UITextAlignmentCenter
    @label.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    @label.textColor = UIColor.whiteColor
    @label.adjustsFontSizeToFitWidth = true
    @label.backgroundColor = UIColor.clearColor
    addSubview @label
  end
  
  def setHighlighted highlighted
    super
    # self.backgroundColor = highlighted ? UIColor.blackColor : @color
    layer.opacity = highlighted ? 0.8 : 1
  end
  
  def title= text
    @label.text = text.to_s.upcase
    return if text.nil? or text == ''
    textHeight = text.sizeWithFont(@label.font).height
    @label.frame = [[@label.frame.origin.x,(self.frame.size.height - textHeight) * 0.5 ],[@label.frame.size.width,textHeight]]
  end
  def color= color
    @color = color
    self.backgroundColor = color
  end
  
end