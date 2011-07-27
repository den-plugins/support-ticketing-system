require 'support_ticketing_system'

class Issue < ActiveRecord::Base
  include SupportTicketingSystem::Settings

  def mystic_ticket?
    self.author_id == MYSTIC_USER_ID && self.project.identifier == MYSTIC_PROJECT_IDENTIFIER
  end
end
