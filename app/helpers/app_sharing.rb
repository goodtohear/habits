class AppSharing
  def activityViewController activityViewController, itemForActivityType: activityType
    if(activityType == UIActivityTypePostToTwitter)
      return "I like using the Good Habits app by @goodtohearuk to make myself a better person"
    end      
    if activityType == UIActivityTypePostToFacebook
      return "Good Habits is making me sort my life out."
    end
    if activityType == UIActivityTypeMail
      return "Hi, I thought you might find this app useful.  It's a free to-do list app that motivates you keep doing something every day."
    end
    nil
  end
end