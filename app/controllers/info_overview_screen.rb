class InfoOverviewScreen < UIViewController
  def init
    if super
      build
    end
    self
  end
  def build
    view.backgroundColor = UIColor.whiteColor
    
    @how_to_use = Button.create [[30,30],[260,40]], title: "How to use", color: UIColor.blackColor
    @how_to_use.when(UIControlEventTouchUpInside) do
      presentViewController InformationScreen.alloc.init, animated: true, completion: ->(){}
    end
    view.addSubview @how_to_use
    
    @done = Button.create [[30,100],[260,40]], title: "Done", color: UIColor.blackColor
    @done.when(UIControlEventTouchUpInside) do
      dismissViewControllerAnimated true, completion: ->(){}
    end
    view.addSubview @done
    
    
    
  end
end