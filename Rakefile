# -*- coding: utf-8 -*-
Dir.glob('lib/tasks/*.rake').each { |r| import r }
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'yaml'
require 'bundler'
Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  app.deployment_target = "5.0"
  app.sdk_version = "6.1"
  app.identifier = 'goodtohear.habits'
  app.version = app.info_plist['CFBundleShortVersionString'] = "1.1.2"
  
  app.name = 'Habits'
  app.icons += ['icon_57','icon_114.png']
  app.prerendered_icon = true
  app.frameworks += ["QuartzCore"]
  app.interface_orientations = [:portrait]
  app.info_plist['UIStatusBarStyle'] = 'UIStatusBarStyleBlackOpaque'
  # app.info_plist['UIStatusBarHidden'] = false
  
  
  app.pods do
    pod 'SwipeView', '~> 1.2.10'
    pod 'TestFlightSDK'
  end
  
  app.vendor_project('vendor/ReorderingTableViewController', :static, :headers_dir => '.', :cflags => '-fobjc-arc')


  app.development do 
    app.codesign_certificate = 'iPhone Developer: Michael Forrest (2Y46T85LFL)'
    app.provisioning_profile = 'profiles/Testing.mobileprovision'
  end
  app.testflight do
    app.codesign_certificate = 'iPhone Distribution: Good To Hear Ltd'
    app.provisioning_profile = 'profiles/Testing.mobileprovision'

    app.entitlements['get-task-allow'] = false
    app.testflight.api_token = ENV['TESTFLIGHT_API_TOKEN'] || abort("You need to set your Testflight API Token environment variable.")
    app.testflight.team_token = '359d8287044267ba5584957afcb44f57_MTE1NDM5MjAxMi0wNy0yOSAwODo0MTo1My4zMzk5MTI'
  end
  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = 'iPhone Distribution: Good To Hear Ltd'
    app.provisioning_profile = 'profiles/Distribution.mobileprovision'

  end

end

Motion::SettingsBundle.setup do |app|
  app.multivalue "Start of day", :key=> "start_of_day", :default=> 6, :values=> (0..23).to_a, :titles=> (0..23).map{|t| "#{t.to_s.rjust(2,'0')}:00"}
end

