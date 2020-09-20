# SAAS starts here
namespace :db do
  desc 'Load an initial set of data'
  task bootstrap: :environment do
    puts 'Creating Databses...'
    Rake::Task['db:create'].invoke
    abort('DB contains more than 3 accounts : check DB endpoint') if ActiveRecord::Base.connection.table_exists?('accounts') && Account.count > 3
    return if Rails.env.production?
    puts 'Creating tables...'
    # Rake::Task['db:migrate'].invoke
    Rake::Task['db:schema:load'].invoke

    ENV["FIXTURE_PATH"] = "db/fixtures"
    Rake::Task['db:seed_fu'].invoke

    puts "All done!  You can now login to the test account at the localhost domain with the login #{AppConfig['EMAILS']['admin_email']} and password test1234.\n\n"
  end
end
