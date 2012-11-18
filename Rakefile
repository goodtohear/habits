# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
# require 'motion-testflight'
require 'bubble-wrap'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  app.deployment_target = "5.0"
  app.identifier = 'goodtohear.habits'
  app.version = "1.0"
  
  app.name = 'Habits'
  app.icons += ['icon_57','icon_114.png']
  app.prerendered_icon = true
  app.frameworks += ["QuartzCore"]
  app.info_plist['UIStatusBarStyle'] = 'UIStatusBarStyleBlackOpaque'
  
  app.pods do
    pod 'DDPageControl'
    pod 'SwipeView'
  end
end