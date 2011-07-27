module SupportTicketingSystem
  def self.toggle_feature(enable=true)
    if features = ENV["features"]
      sts_settings = YAML.load_file("#{RAILS_ROOT}/vendor/plugins/support_ticketing_system/sts.yml")["sts"]
      if((split_features = features.split(",")).is_a? Array) && split_features.size > 1
        split_features.each do |feature|
          unless sts_settings["#{feature}_feature"].nil?
            sts_settings["#{feature}_feature"] = enable
            puts "\n============== #{enable ? 'Enabled' : 'Disabled'} '#{feature}' Den::STS feature \n\n"
          else
            puts "\n============== Warning '#{feature}' feature does not exists (has no implementations or no such feature).\n"
          end
        end
      else
        sts_settings["#{features}_feature"] = enable
        puts "\n============== #{enable ? 'Enabled' : 'Disabled'} '#{features}' Den::STS feature\n\n"
      end
      File.open("#{RAILS_ROOT}/vendor/plugins/support_ticketing_system/sts.yml", 'w' ) do |out|
        YAML.dump( {"sts" => sts_settings}, out )
      end
    else
      puts "\n============== Nothing happened\nProvide feature(s) to #{enable ? 'enable' : 'disable'} => rake den:sts:features:#{enable ? 'enable' : 'disable'} features=monitor (or features=monitor,subscribe)\n\n"
    end
  end
end

desc "Enable or disable Integrated Support Ticketing features"
namespace :den do
  namespace :sts do
    namespace :features do
      task :enable => :environment do
        SupportTicketingSystem.toggle_feature
      end
      task :disable => :environment do
        SupportTicketingSystem.toggle_feature false
      end
    end
  end
end
