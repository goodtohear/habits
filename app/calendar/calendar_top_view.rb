class CalendarTopView < UIView
  attr_reader :label, :prev_button, :next_button
  def initWithFrame frame
    if super
      build
    end
    self
  end
  def build
    self.backgroundColor = '#8A95A1'.to_color
    @label = HeaderLabel.alloc.initWithFrame [[0,14],[320,24]]
    @label.font = UIFont.fontWithName "Helvetica-Bold", size: 20
    addSubview @label

    @label.text = "JANUARY 2012"
    
    
    @prev_button =  UIButton.buttonWithType UIButtonTypeCustom
    @prev_button.frame = [[0,0], [44,45]]
    @prev_button.setImage UIImage.imageNamed("arrow_back"), forState: UIControlStateNormal
    addSubview @prev_button

    @next_button = UIButton.buttonWithType UIButtonTypeCustom
    @next_button.frame =  [[320-44,0],[44,45]]
    @next_button.setImage UIImage.imageNamed("arrow_next"), forState: UIControlStateNormal
    addSubview @next_button
    
    
    %w[Sun Mon Tue Wed Thu Fri Sat].each_with_index do |dayName, index|
      label = UILabel.alloc.initWithFrame [[15 + index * 45,40],[18,11]]
      label.text = dayName
      label.backgroundColor = UIColor.clearColor
      label.font = UIFont.fontWithName "Helvetica-Bold", size: 8
      label.textColor = UIColor.whiteColor
      addSubview label
    end
    
  end
  
end