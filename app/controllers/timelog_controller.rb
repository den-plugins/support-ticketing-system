require 'support_ticketing_system'
class TimelogController < ApplicationController
  include SupportTicketingSystem::Settings
  private
    def call_mystic_process_billable_hours(issue_id, num_of_hours)
      if @issue && @issue.mystic_ticket? && is_process_billable_hours_enabled?
        redmine_params = {"redmine_id" => issue_id, "num_of_hours" => num_of_hours, "interface_token" => AUTH_TOKEN}
        url = "#{MORPH_EXCHANGE_BASE_URL}process_billable_hours"
        if(res = Interface.new(url, 'POST', redmine_params).get_object["hash"])
          if res["hours_processed"]
            flash[:notice] = l(:notice_successful_update)
            return(redirect_back_or_default :action => 'details', :project_id => @time_entry.project)
          else
            TimeEntry.connection.rollback_db_transaction
            @time_entry.errors.add_to_base "Failed to bill the customer."
          end
        else
          TimeEntry.connection.rollback_db_transaction
          return(render_404)
        end
      else
        flash[:notice] = l(:notice_successful_update)
        return(redirect_back_or_default :action => 'details', :project_id => @time_entry.project)
      end
    end
end
