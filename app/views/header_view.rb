class HeaderView < UIView
  attr_reader :info,:settings
  def initWithFrame frame
    if super
      build
    end
    self
  end
  def build
    self.backgroundColor = '#3A4450'.to_color
    
    @label = UILabel.alloc.initWithFrame [[100,11],[320-200, 20]]
    @label.text = "Good Habits"
    @label.font = UIFont.fontWithName 'PlayfairDisplay-Italic', size: 20
    @label.backgroundColor = UIColor.clearColor
    @label.textColor = UIColor.whiteColor
    @label.textAlignment = UITextAlignmentCenter
    addSubview @label
    
    
    @info = UIButton.buttonWithType UIButtonTypeCustom
    @info.frame = [[4,2], [44,45]]
    @info.setImage UIImage.imageNamed("info"), forState: UIControlStateNormal
    addSubview @info
    
    @settings = UIButton.buttonWithType UIButtonTypeCustom
    @settings.frame = [[270,0], [44,45]]
    @settings.setImage UIImage.imageNamed("settings"), forState: UIControlStateNormal
    addSubview @settings
  end
  
end