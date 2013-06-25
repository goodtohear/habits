class InfoTask
  attr_accessor :text, :action, :color, :id, :due


  def self.due
    @due ||= all.select(&:due?)
    
  end
  def self.all
    @all ||= [
      InfoTask.create(:instructions, text: "Read the instructions", color: Colors::GREEN, due: 0, action: ->(controller){
        controller.presentViewController InformationScreen.alloc.init, animated: true, completion: ->(){}
        }),
      InfoTask.create(:happiness, text: "Check out Happiness", color: Colors::YELLOW, due:3, action: ->(controller){
          App.open_url "http://goodtohear.co.uk/happiness?from=habits"
        }),
      InfoTask.create(:rate, text: "Rate the app", color: Colors::PURPLE, due:3, action: ->(controller){
          App.open_url "https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=573844300&type=Purple+Software"
        }),
      InfoTask.create(:like, text: "Like us on Facebook", color: Colors::BLUE, due:3, action: ->(controller){
          App.open_url "https://www.facebook.com/298561953497621"
        }),
      InfoTask.create(:share, text: "Share the app", color: Colors::ORANGE, due:3, action: ->(controller){
          items = ["I like using the Good Habits app by @goodtohearuk to make myself a better person", NSURL.URLWithString("https://itunes.apple.com/gb/app/good-habits/id573844300?mt=8")]

          sheet = UIActivityViewController.alloc.initWithActivityItems items, applicationActivities: nil
          sheet.excludedActivityTypes = [ UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToWeibo]
          controller.presentViewController(sheet, animated:true, completion:nil)
        })
    ]
  end
  def self.create(id, text: text, color: color, due: due, action: action)
    task = InfoTask.new
    task.due = due
    task.id = id
    task.text = text
    task.color = color
    task.action = action
    task.load!
    task
  end

  def open(controller)
    mark_opened!
    @action.call(controller)
  end
  def mark_opened!
    @opened = true
    save!
  end
  def opened?
    @opened
  end
  def toggle(done)
    @done = done
    save!
  end
  def done?
    @done
  end
  def not_done?
    !@done
  end
  def load!
    info = App::Persistence["info_task_#{@id}"] || {}
    @opened = info[:opened] || false
    @done = info[:done] || false
  end
  def save!
    App::Persistence["info_task_#{@id}"] = {
      opened: @opened,
      done: @done
    }
  end
  def self.not_done_count 
    due.select(&:not_done?).count
  end

  def due?
    installed_date = App::Persistence['installed_date']
    return true if installed_date.nil?
    installed_date + due.days < Time.now
  end

end