# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'yaml'
require 'bundler'
Bundler.setup
Bundler.require

def load_config(app)
=begin

  Create a config.yml in the following format: 

  development:
    codesign_certificate: 'iPhone Developer: Your Name (12345678)'
    provisioning_profile: "/path/to/profile.mobileprovision"

  release:
    codesign_certificate: 'iPhone Distribution: Your Company'
    provisioning_profile: "/path/to/profile.mobileprovision"

=end

  config = YAML::load( File.open('config.yml') )
  for mode in config.keys
    app.send(mode) do
      for key, value in config[mode]
        app.send "#{key}=", value
      end
    end
  end
end

Motion::Project::App.setup do |app|
  load_config(app) if File.exists? 'config.yml'
  
  app.deployment_target = "5.0"
  app.sdk_version = "6.1"
  app.identifier = 'goodtohear.habits'
  app.version = app.info_plist['CFBundleShortVersionString'] = "1.1.1"
  
  app.name = 'Habits'
  app.icons += ['icon_57','icon_114.png']
  app.prerendered_icon = true
  app.frameworks += ["QuartzCore"]
  app.interface_orientations = [:portrait]
  app.info_plist['UIStatusBarStyle'] = 'UIStatusBarStyleBlackOpaque'
  # app.info_plist['UIStatusBarHidden'] = false
  
  
  app.pods do
    pod 'SwipeView'
    pod 'TestFlightSDK'
  end
  
  app.vendor_project('vendor/ReorderingTableViewController', :static, :headers_dir => '.', :cflags => '-fobjc-arc')
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