class LinkCell < UITableViewCell
  def initWithStyle style, reuseIdentifier: identifier
    if super
      build
    end
    self
  end
  def build
    self.backgroundColor = UIColor.whiteColor
    @backgroundColorView = UIView.alloc.initWithFrame [[0,0],self.frame.size]
    @backgroundColorView.backgroundColor = Colors::GREEN
    @backgroundColorView.hidden = true
    addSubview @backgroundColorView
    self.selectionStyle = UITableViewCellSelectionStyleNone
    
    @label = UITextField.alloc.initWithFrame [[10,8],[280,30]]
    @label.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 20
    @label.minimumFontSize = 10
    @label.textColor = Colors::DARK
    @label.adjustsFontSizeToFitWidth = true
    @label.userInteractionEnabled = false
    @label.delegate = self
    addSubview @label

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator
  end
  def setHighlighted selected, animated: animated
    super
    @backgroundColorView.hidden = !selected
    @label.textColor = selected ? UIColor.whiteColor : Colors::DARK
  end
  def link= link
    @label.text = link[:text]
  end
end