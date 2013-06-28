class InfoTask
  attr_accessor :text, :action, :color, :id, :due


  def self.due
    all.select(&:due?)
    
  end
  def self.all
    @all ||= [
      InfoTask.create(:guide, due: 0, text: "Look at the guide", color: Colors::GREEN, action: ->(controller){
        controller.presentViewController InformationScreen.alloc.init, animated: true, completion: ->(){}
        }),
      InfoTask.create(:share, due: 0, text: "Share this app", color: Colors::ORANGE, action: ->(controller){
          Appearance.remove()
          items = [AppSharing.alloc.init, NSURL.URLWithString("https://itunes.apple.com/gb/app/good-habits/id573844300?mt=8")]

          sheet = UIActivityViewController.alloc.initWithActivityItems items, applicationActivities: nil
          sheet.excludedActivityTypes = [ UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToWeibo]
          sheet.completionHandler = ->(activityType, completed){
            Appearance.apply()
          }
          controller.presentViewController(sheet, animated:true, completion: nil)

        }),
      InfoTask.create(:happiness, due: 3, text: "Get Happiness", color: Colors::YELLOW, action: ->(controller){
          App.open_url "http://goodtohear.co.uk/happiness?from=habits"
        }),
      InfoTask.create(:rate, due: 3, text: "Rate this app", color: Colors::PURPLE,  action: ->(controller){
          App.open_url "https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=573844300&type=Purple+Software"
        }),
      InfoTask.create(:like, due: 3, text: "Like us on Facebook", color: Colors::BLUE, action: ->(controller){
          App.open_url "https://www.facebook.com/298561953497621"
        })
    ]
  end
  def self.create(id, due: due, text: text, color: color, action: action)
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
  def unopened?
    !opened?
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
  def self.unopened_count 
    due.select(&:unopened?).count
  end

  def due?
    installed_date = App::Persistence['installed_date']
    return true if installed_date.nil?
    installed_date + due.days < Time.now
  end
  def reset!
    @opened = false
    @done = false
  end
  def self.reset_all!
    for task in all
      task.reset!
      task.save!
    end
  end
end