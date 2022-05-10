# SAAS starts here
namespace :db do
  desc 'Load an initial set of data'
  task bootstrap: :environment do
    abort('Danger!! PRODUCTION ENV..') if Rails.env.production?
    abort('DB contains more than 3 accounts : check DB endpoint') if ActiveRecord::Base.connection.table_exists?('accounts') && Account.count > 3
    Rake::Task['db:reset'].invoke
    Rake::Task['db:create'].invoke
    puts 'Creating tables...'
    Rake::Task['db:migrate'].invoke
    # Rake::Task['db:schema:load'].invoke

    ENV["FIXTURE_PATH"] = "db/fixtures"
    # Sharding.execute_on_all_shards do
      Rake::Task['db:seed_fu'].invoke
    # end

    puts "All done!  You can now login to the test account at the localhost domain with the login #{AppConfig['EMAILS']['admin_email']} and password test1234.\n\n"
  end

  task create_all: :environment do
    puts 'Creating Databses...'
    Sharding.execute_on_all_shards do
      Rake::Task['db:create'].invoke
    end
  end

  task reset_all: :environment do
    puts 'Resetting Databses...'
    Sharding.execute_on_all_shards do
      Rake::Task['db:reset'].invoke
    end
  end

  task drop_all: :environment do
    puts 'Creating Databses...'
    Sharding.execute_on_all_shards do
      Rake::Task['db:drop'].invoke
    end
  end
end
