namespace :db do
  namespace :data do
    desc "Run all data migrations"
    task :migrate => :environment do
      require 'efg/data_migrator'
      options = if Rake.verbose
        nil
      else
        { logger: Logger.new("/dev/null") }
      end
      EFG::DataMigrator.new(options).run
    end
  end
end
