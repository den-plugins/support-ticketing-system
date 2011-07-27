require 'support_ticketing_system'
module IssuesHelper
  include SupportTicketingSystem::Settings
  def credit_rollback_link(issue)
    return unless is_rollback_credit_enabled?
    link_to(l(:button_rollback_credit), rollback_credit_path(issue), :class => "icon icon-rollback-credit") if issue.mystic_ticket?
  end
end
