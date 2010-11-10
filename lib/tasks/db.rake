namespace :db do
  desc 'Clear all collections'
  task :clear => :environment do
    [
      Cache,
      FilterGroup,
      Group,
      GroupUser,
      Node,
      Setting,
      Tagging,
      Term,
      User,
      Vocabulary
    ].each { |model| model.delete_all }
    puts 'Database truncated'
  end
end