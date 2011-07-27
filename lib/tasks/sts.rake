desc "Add fixtures in app(den) and run db:fixtures:load and after that revert app's fixtures state"

namespace :db do
  namespace :fixtures do
    task :load_including_sts_fixtures => :environment do
      # append fixture files [users, projects, members, issues, enabled_modules]
      app_fixtures_path = "#{RAILS_ROOT}/test/fixtures/"
      sts_engine_fixtures_path = "#{RAILS_ROOT}/vendor/plugins/support_ticketing_system/test/fixtures/"
      fixture_filenames = ['users.yml', 'projects.yml', 'members.yml', 'issues.yml', 'enabled_modules.yml', 'projects_trackers.yml']

      # backup first the counterpart of these engine plugin fixture in test/fixtures
      fixture_filenames.each do |fixture_filename|
        system "cp #{app_fixtures_path}#{fixture_filename} #{sts_engine_fixtures_path}backup_#{fixture_filename}"
      end
      # append the fixtures
      fixture_filenames.each do |fixture_filename|
        appended_fixture_file =  "#{fixture_filename}"
        system "cd #{app_fixtures_path} && cat #{appended_fixture_file} #{sts_engine_fixtures_path}#{fixture_filename} >  backup_#{appended_fixture_file} && cp  backup_#{appended_fixture_file} #{appended_fixture_file} && rm  backup_#{appended_fixture_file}"
      end

      # run rake db:fixtures:load
      system "cd #{RAILS_ROOT} && rake db:fixtures:load"

      # revert back app's fixtures state prior append
      #  cp back the backup fixtures to app fixtures
      fixture_filenames.each do |fixture_filename|
        system "cp #{sts_engine_fixtures_path}backup_#{fixture_filename} #{app_fixtures_path}#{fixture_filename}"
      end

      # delete backup files
      fixture_filenames.each do |fixture_filename|
        system "cd #{sts_engine_fixtures_path} && rm backup_#{fixture_filename}"
      end
    end
  end
end
