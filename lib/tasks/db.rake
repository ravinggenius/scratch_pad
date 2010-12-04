namespace :db do
  desc 'Clear all collections'
  task :clear => :environment do
    [
      Addon,
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
    ].each &:delete_all
    puts 'Database truncated'
  end
end