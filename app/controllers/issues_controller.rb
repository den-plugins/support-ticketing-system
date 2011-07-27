require 'support_ticketing_system'

class IssuesController < ApplicationController
  include SupportTicketingSystem::Settings

  def rollback_credit
    if(@issue = Issue.find_by_id(params[:id])) 
      redmine_params = {"redmine_id" => @issue.id, "interface_token" => AUTH_TOKEN}
      url = "#{MORPH_EXCHANGE_BASE_URL}rollback"

      if(res = Interface.new(url, 'POST', redmine_params).get_object["hash"])
        if res["rollback"]
          flash[:notice] = "Successful credit rollback."
          redirect_to :back
        else
          render_error res["error"]
        end
      else
        render_404
      end

    else

      render_404
    end
  end

  private
    def update_ticket_at_mystic?
      @issue.mystic_ticket? && params[:selected_update] && (params[:selected_update].to_i == 2)
    end

    def update_mystic_ticket(issue, notes)
      redmine_params = {"redmine_id"      => issue.id,
                        "interface_token" => AUTH_TOKEN,
                        "redmine_status"  => issue.status_id,
                        "update_msg"      => notes}
      url = "http://support.morphexchange.com/rest_api/update_ticket"

      if(res = Interface.new(url, 'POST', redmine_params).get_object["hash"])
        if res["update_status"]
          return(redirect_to(params[:back_to] || {:action => 'show', :id => @issue}))
        else
          Issue.connection.rollback_db_transaction
          flash.clear
          return(render_error "Update failed. Cannot update ticket at mystic.")
        end
      else
        flash.clear
        Issue.connection.rollback_db_transaction
        return render_404
      end
    end
end
