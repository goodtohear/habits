# Author: Michael Forrest | Good To Hear | http://goodtohear.co.uk | License terms: credit me.
class CalendarDayViewController < UIViewController
  def add_view view
    self.view = view
    @isOn = false # TODO: move to model
    view.when_tapped do
      @isOn = !@isOn
      view.toggle @isOn
    end
  end
end