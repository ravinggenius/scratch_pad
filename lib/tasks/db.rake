namespace :db do
  desc 'Clear all collections'
  task :clear => :environment do
    Cache.delete_all
    Node.delete_all
    Tagging.delete_all
    Term.delete_all
    Vocabulary.delete_all
  end

  desc 'Load the seed data from db/seeds.rb'
  task :seed => :environment do
    seed_file = File.join(Rails.root, 'db', 'seeds.rb')
    load(seed_file) if File.exist?(seed_file)
  end
end