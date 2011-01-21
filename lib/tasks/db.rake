namespace :db do
  desc 'Clear all collections'
  task :clear => :environment do
    [
      AddonConfiguration,
      Cache,
      FilterGroup,
      Group,
      GroupUser,
      Layout,
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