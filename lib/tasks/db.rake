namespace :db do
  desc 'Clear all collections'
  task :clear => :environment do
    [
      Cache,
      FilterGroup,
      Group,
      GroupUser,
      Node,
      Option,
      Setting,
      Tagging,
      Term,
      User,
      Value,
      Vocabulary
    ].each { |model| model.delete_all }
    puts 'Database truncated'
  end
end