class InfoCell < CellWithCheckBox
  attr_accessor :controller
  def build
    super
    @label.frame = [@label.frame.origin, [260, @label.frame.size.height]]
    @new_label = UILabel.alloc.initWithFrame [[260, 12], [35,18]]
    @new_label.textColor = UIColor.whiteColor
    @new_label.backgroundColor = Colors::RED
    @new_label.textAlignment = UITextAlignmentCenter
    @new_label.font = UIFont.fontWithName("HelveticaNeue-Bold", size:11)
    @new_label.text = "NEW"
    addSubview @new_label

    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    @checkbox.when_tapped do
      # respond to tap
      @task.toggle(!@task.done?)
      mark_read
      @checkbox.set_checked @task.done?

      unless @task.opened?
        @task.open(@controller)
      end
    end
  end
  def task= task
    @task = task
    mark_read if @task.opened? 
    @label.text = @task.text
    @checkbox.set_checked @task.done?
  end
  def mark_read
    # @label.textColor = Colors::COBALT
    @new_label.hidden = true
  end
  def textColor
    Colors::DARK
    # (@task and @task.opened?) ? Colors::COBALT : UIColor.blackColor
  end
end