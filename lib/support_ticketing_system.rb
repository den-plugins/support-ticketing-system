require 'yaml'

module SupportTicketingSystem
  module Settings
    sts_settings = YAML.load_file("#{RAILS_ROOT}/vendor/plugins/support_ticketing_system/sts.yml")["sts"]
    
    MORPH_EXCHANGE_BASE_URL        = sts_settings["morph_exchange_base_url"] # the key explains it
    MYSTIC_USER_ID                 = sts_settings["mystic_user_id"] # it is the Den user that's used by mystic for it's create issue call
    MYSTIC_PROJECT_IDENTIFIER      = sts_settings["mystic_project_identifier"] # issues will be placed under this project

    def is_process_billable_hours_enabled?
      YAML.load_file("#{RAILS_ROOT}/vendor/plugins/support_ticketing_system/sts.yml")["sts"]["process_billable_hours_feature"]
    end

    def is_rollback_credit_enabled?
      YAML.load_file("#{RAILS_ROOT}/vendor/plugins/support_ticketing_system/sts.yml")["sts"]["rollback_credit_feature"]
    end
  end
end
