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