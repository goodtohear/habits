class CalendarDayViewController < UIViewController
  def add_view view
    self.view = view
    @isOn = false # TODO: move to model
    view.whenTapped do
      @isOn = !@isOn
      view.toggle @isOn
    end
  end
end