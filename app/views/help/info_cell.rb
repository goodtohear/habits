class InfoCell < CellWithCheckBox
  attr_accessor :controller
  def build
    super
    @label.frame = [@label.frame.origin, [260, @label.frame.size.height]]
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
    @label.font = UIFont.fontWithName 'HelveticaNeue', size: @label.font.pointSize
  end
end