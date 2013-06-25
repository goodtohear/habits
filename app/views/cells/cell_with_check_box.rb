class CellWithCheckBox < UITableViewCell
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
    
    @label = UITextField.alloc.initWithFrame [[42,8],[194,30]]
    @label.font = UIFont.fontWithName 'HelveticaNeue-Bold', size: 20
    @label.minimumFontSize = 10
    @label.adjustsFontSizeToFitWidth = true
    @label.userInteractionEnabled = false
    @label.delegate = self
    addSubview @label


    @checkbox = CheckBox.alloc.initWithFrame [[0,0], [44,44]]
    addSubview @checkbox

  end
  def set_color color
    @color = color
    @checkbox.set_color color
    @backgroundColorView.backgroundColor = color
  end
  def setHighlighted selected, animated: animated
    super
    @backgroundColorView.hidden = !selected
    @label.textColor = selected ? UIColor.whiteColor : textColor
  end
end