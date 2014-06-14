class DataExport
  def self.run(controller)
    #SVProgressHUD.showWithStatus "Exporting...", maskType: SVProgressHUDMaskTypeBlack
    habits = Habit.all.map do |habit|
      {
        title: habit.title,
        created_at: habit.created_at.to_s,
        time_to_do: habit.no_reminders? ? nil : "#{habit.time_to_do}:#{habit.minute_to_do}",
        days_required: Calendar::DAYS.each_with_index.map{|d, i| habit.days_required[i] ? d : nil}.compact, 
        active: habit.active,
        longest_chain: habit.longestChain,
        current_chain: habit.currentChainLength,
        color: habit.hex_color,
        days_checked: habit.days_checked.keys
      }
    end
    NSLog "DATA: #{habits}"
    json = BW::JSON.generate habits
    NSLog " JSON: #{json}"
    
    hash = [json].pack('m')
    #SVProgressHUD.dismiss # placeholder in case I make this asynchronous

    BW::MailWithAttachment.compose({
      delegate: controller,
      html: true,
      subject: "Habits data",
      message: "Attached is a JSON file of data exported from Habits by <a href='http://goodtohear.co.uk'>Good To Hear</a>.  To restore this data to the app, tap this <a href='goodhabits://import?json=#{hash}'>RESTORE LINK</a>.",
      attachments: [
        {data: json.dataUsingEncoding(NSUTF8StringEncoding), mimeType: 'application/json', fileName: 'habits_data.json'}
      ]
    }) do |result, error|
      NSLog "Result #{result} error: #{error}"
    end
  end
end
