class AppSharing
  def activityViewController activityViewController, itemForActivityType: activityType
    # HACK: Bring back contants after I've released the fix for iOS 5.1
    if activityType == "com.apple.UIKit.activity.PostToTwitter" # UIActivityTypePostToTwitter)
      return "I like using the Good Habits app by @goodtohearuk to make myself a better person"
    end      
    if activityType == "com.apple.UIKit.activity.PostToFacebook" #UIActivityTypePostToFacebook
      return "Good Habits is making me sort my life out."
    end
    if activityType == "com.apple.UIKit.activity.Mail" #UIActivityTypeMail
      return "Hi, I thought you might find this app useful.  It's a free to-do list app that motivates you keep doing something every day."
    end
    nil
  end
end
