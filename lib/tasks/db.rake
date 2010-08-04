namespace :db do
  desc 'Clear all collections'
  task :clear => :environment do
    [
      Cache,
      Node,
      Tagging,
      Term,
      Vocabulary
    ].each { |model| model.delete_all }
    puts 'Database truncated'
  end

  desc 'Load the seed data from db/seeds.rb'
  task :seed => :environment do
    seed_file = File.join(Rails.root, 'db', 'seeds.rb')
    load seed_file if File.exist? seed_file
    puts 'Database has been seeded'
  end
end