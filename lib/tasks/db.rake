namespace :db do
  desc 'Clear all collections'
  task :clear => :environment do
    MongoMapper.database.collections.each &:remove
    puts 'Database truncated'
  end
end