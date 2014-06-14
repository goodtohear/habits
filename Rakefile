# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'yaml'
require 'bundler'
Bundler.setup
Bundler.require

#ENV['COCOAPODS_NO_UPDATE']='1'

Motion::Project::App.setup do |app|
  app.deployment_target = "7.0"
  app.sdk_version = "7.1"
  app.identifier = 'goodtohear.habits'
  app.version = app.info_plist['CFBundleShortVersionString'] = "1.1.5"

  app.name = 'Habits'
  app.icons += ['icon_57','icon_114.png','icon_120.png']
  app.prerendered_icon = true
  app.frameworks += ["QuartzCore"]
  app.interface_orientations = [:portrait]
  app.info_plist['UIStatusBarStyle'] = 'UIStatusBarStyleBlackOpaque'
  # app.info_plist['UIStatusBarHidden'] = false
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'goodtohear.habits',
      'CFBundleURLSchemes' => ['goodhabits'] }
  ]

  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false

  app.pods do
    pod 'SwipeView'
    pod 'PonyDebugger'
    pod 'SVProgressHUD'
    # pod 'TestFlightSDK', '~> 2.0'
  end

  app.vendor_project('vendor/ReorderingTableViewController', :static, :headers_dir => '.', :cflags => '-fobjc-arc')


  app.development do
    app.codesign_certificate = 'iPhone Developer: Michael Forrest (2Y46T85LFL)'
    app.provisioning_profile = 'profiles/Testing.mobileprovision'
    app.entitlements['get-task-allow'] = true
  end
#  app.testflight do
#    app.codesign_certificate = 'iPhone Distribution: Good To Hear Ltd'
#    app.provisioning_profile = 'profiles/Testing.mobileprovision'
#
#    app.entitlements['get-task-allow'] = false
#    app.testflight.api_token = ENV['TESTFLIGHT_API_TOKEN'] || abort("You need to set your Testflight API Token environment variable.")
#    app.testflight.team_token = '359d8287044267ba5584957afcb44f57_MTE1NDM5MjAxMi0wNy0yOSAwODo0MTo1My4zMzk5MTI'
#  end
  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = 'iPhone Distribution: Good To Hear Ltd'
    app.provisioning_profile = 'profiles/Distribution.mobileprovision'

  end

end


desc "symbolicate log"
task :symbolicate do
  base_address = "0x37000" # for now.
  path = Dir['crashes/*.crash'].first
  lines = File.read(path).to_a
  Dir.chdir 'build/iPhoneOS-5.0-Release' do
    addresses = []
    lines.each do |line|
      line_number, app_name, address = line.split
      if app_name == "Habits"
        addresses << address

      end
    end
    puts system "atos -o Habits.app/Habits -l #{base_address} #{addresses.join(' ')}"
  end
end

desc "convert json to import link"
task :json_to_link do
  json_path = "/Users/mf/Downloads/habits_data.json"
  json = File.read json_path
  hash = [json].pack('m')
  link = "<a href='goodhabits://import?json=#{hash}'>RESTORE LINK</a>"
  puts "link: #{link}"
  system "echo \"#{link}\" | textutil -stdin -format html -convert rtf -stdout | pbcopy"
  puts "Link has been copied to the clipboard (sort of)."
end
