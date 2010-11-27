def password(length = 12)
  alphanumerics = [('0'..'9'), ('A'..'Z'), ('a'..'z')].map { |range| range.to_a }.flatten
  (0...length).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
end

def puts_loud(phrase)
  puts "!IMPORTANT: #{phrase}"
end

def puts_table(data, fields, caption = nil)
  puts "#{caption}\n" unless caption.nil?
  puts Hirb::Helpers::AutoTable.render(data, :fields => fields, :header_filter => :capitalize)
end

namespace :sp do
  desc 'Sets up users, groups and settings required for ScratchPad to operate'
  task :install do
    Rake::Task['sp:install:settings'].invoke
  end

  namespace :install do
    desc 'Adds the required settings'
    task :settings => [:environment, :users] do
      [
        { :scope => 'sp.site.name',                :name => 'Site Name',               :value => 'ScratchPad' },
        { :scope => 'sp.site.tagline',             :name => 'Site Tagline',            :value => '...' },
        { :scope => 'sp.user.password.min_length', :name => 'Minimum Password Length', :value => 8 }
      ].each do |hash|
        setting = Setting.first_or_create :scope => hash[:scope]
        setting.update_attributes hash if setting.new?
      end

      [
        Filter,
        NodeExtension,
        Theme,
        Widget
      ].each &:install

      puts 'Default settings have been loaded'
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
        puts_loud "The root password was set to #{root_password}. There is no way to recover this, so be sure to store it securely."
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
  end

  desc 'Load the example content from db/seeds.rb. Should be used for Theme screenshots'
  task :seed => :environment do
    Rake::Task['sp:install:users'].invoke
    seed_file = Rails.root + 'db' + 'seeds.rb'
    load seed_file if seed_file.exist?
    puts 'Database has been seeded'
  end

  desc 'List all Addons, grouped by type and status'
  task :addons do
    [
      :filters,
      :node_extensions,
      :themes,
      :widgets
    ].each { |addon| Rake::Task["sp:addons:#{addon}"].invoke }
  end

  namespace :addons do
    desc 'List Filters with the FilterGroups they belong to'
    task :filters => :environment do
      puts_table Filter.all, [:name, :title], 'Filters'
      puts
    end

    desc 'List NodeExtensions with a usage count'
    task :node_extensions => :environment do
      puts_table NodeExtension.all, [:name, :title], 'Node Extensions'
      puts
    end

    desc 'List Widgets'
    task :widgets => :environment do
      puts_table Widget.all, [:name, :title], 'Widgets'
      puts
    end

    desc 'List Themes with status grouped by frontend/backend'
    task :themes => :environment do
      puts_table Theme.frontend, [:name, :title], 'Frontend Themes'
      puts
      puts_table Theme.backend, [:name, :title], 'Backend Themes'
      puts
    end

    namespace :themes do
      desc 'Set a Theme as active. Useful for emergency recovery from a broken Theme'
      task :activate, :backend_or_frontend, :template, :needs => :environment do |t, args|
        s = Setting.first_in_scope :addon, :theme, args[:backend_or_frontend]
        s.update_attributes :value => args[:template]
      end
    end
  end
end
