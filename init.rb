require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Starting SUPPORT TICKETING SYSTEM plugin for DEN'

Redmine::Plugin.register :erma do
  name 'DEN SUPPORT TICKETING SYSTEM plugin'
  author 'Exist DEN Team'
  description 'This is a SUPPORT TICKETING SYSTEM plugin for DEN'
  version '0.1.0'
end

require File.dirname(__FILE__) + '/app/models/issue.rb'
