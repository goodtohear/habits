class DayNavigation < UIView
  attr_reader :textLabel
  def init
    if super
      build
    end
    self
  end

  def build
    @textLabel = UILabel.alloc.initWithFrame [[10,0],[300,44]]
    @textLabel.backgroundColor = UIColor.clearColor
    @textLabel.textColor = UIColor.whiteColor
    @textLabel.textAlignment = UITextAlignmentCenter
    @textLabel.font = UIFont.fontWithName "HelveticaNeue-Bold", size: 20
    self.backgroundColor = Colors::COBALT
    addSubview @textLabel
  end
  
  def date= date
    @formatter ||= NSDateFormatter.alloc.init.tap do |df|
      df.dateFormat = "EEEE d MMMM" #Sunday 4 June
    end
    @textLabel.text = @formatter.stringFromDate date
  end
  
end