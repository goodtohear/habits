class InformationScreen < UIViewController
  def init
    if super
      build
    end
    self
  end
  
  def build
    navigationItem.title = "Information"
    @info = UIImageView.alloc.initWithImage UIImage.imageNamed "information"
    view.addSubview @info
  end
  

end