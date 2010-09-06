def password(length = 12)
  alphanumerics = [('0'..'9'), ('A'..'Z'), ('a'..'z')].map { |range| range.to_a }.flatten
  (0...length).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
end

namespace :sp do
  desc 'Sets up users, groups and default settings'
  task :setup => [:environment, :users, :settings] do
  end

  desc 'Adds the required users'
  task :users => [:environment, :groups] do
    anon = User.first_or_new :username => 'anon', :name => 'Anonymous', :email => 'anonymous@example.com'
    anon.password = anon.password_confirmation = password(24)
    anon.groups << Group.first(:code => :locked)
    anon.save

    root = User.first_or_new :username => 'root', :name => 'Administrator', :email => 'root@example.com'
    if root.new?
      root.password = root.password_confirmation = root_password = password
      puts "!IMPORTANT: The root password was set to #{root_password}. There is no way to recover this, so be sure to store it securely."
    end
    root.groups << Group.first(:code => :root)
    root.save

    puts 'Added users and groups'
  end

  desc 'Adds the minimal required user groups'
  task :groups => :environment do
    Group.first_or_create :access_code => 0, :code => :locked, :name => 'Locked Users'
    Group.first_or_create :access_code => 1, :code => :root, :name => 'SuperAdmins'
    puts 'Added groups'
  end

  desc 'Initialize settings'
  task :settings => [:environment, :users] do
    common = { :creator_id => User.anonymous.id, :updater_id => User.anonymous.id }

    Value.create common.merge(:setting_id => Setting.create(:scope => 'core.templates.active', :name => 'Frontend Template').id, :value => 'default')
    Value.create common.merge(:setting_id => Setting.create(:scope => 'core.templates.active.admin', :name => 'Backend Template').id, :value => 'default_admin')
    Value.create common.merge(:setting_id => Setting.create(:scope => 'core.site.name', :name => 'Site Name').id, :value => 'ScratchPad')
    Value.create common.merge(:setting_id => Setting.create(:scope => 'core.site.tagline', :name => 'Site Tagline').id, :value => '...')

    puts 'Default settings have been loaded'
  end

  desc 'Load the seed data from db/seeds.rb'
  task :seed => [:environment, :users] do
    seed_file = File.join(Rails.root, 'db', 'seeds.rb')
    load seed_file if File.exist? seed_file
    puts 'Database has been seeded'
  end

  namespace :scions do
    desc 'List Templates with status'
    task :templates => :environment do
      active_template = Setting['core.templates.active'].value_for(User.anonymous).value
      active_admin_template = Setting['core.templates.active.admin'].value_for(User.anonymous).value
      Template.all.each do |template|
        puts "#{template.title} is #{template.name == active_template ? 'active' : 'inactive'}"
      end
    end
  end
end
