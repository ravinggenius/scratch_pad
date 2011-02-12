def puts_loud(phrase)
  puts "!IMPORTANT: #{phrase}"
end

def puts_table(data, fields, caption = nil)
  puts "#{caption}\n" unless caption.nil?
  puts Hirb::Helpers::AutoTable.render(data, :fields => fields, :header_filter => :titleize)
end

namespace :sp do
  desc 'Sets up users, groups and settings required for ScratchPad to operate'
  task :install do
    Rake::Task['sp:install:settings'].invoke
    Rake::Task['sp:install:enable_minimum_addons'].invoke
    Rake::Task['sp:clear_cache'].invoke
  end

  desc 'Wipe out asset cache and force a rebuild. Requires a server restart'
  task :clear_cache => :environment do
    puts Cache.expire_all
  end

  namespace :install do
    desc 'Adds the required settings'
    task :settings => [:environment, :users] do
      S = Struct.new :scope, :name, :value

      [
        S.new([:site, :name],                  'Site Name',                          'ScratchPad'),
        S.new([:site, :tagline],               'Site Tagline',                       '...'),
        S.new([:user, :password, :min_length], 'Minimum Password Length',            8),
        S.new([:theme, :frontend],             'Frontend Theme',                     :default),
        S.new([:theme, :backend],              'Backend Theme',                      :default_admin),
        S.new([:theme, :support, :khtml],      'Experimental Support For KHTML',     false),
        S.new([:theme, :support, :microsoft],  'Experimental Support For Microsoft', false),
        S.new([:theme, :support, :mozilla],    'Experimental Support For Mozilla',   false),
        S.new([:theme, :support, :opera],      'Experimental Support For Opera',     false),
        S.new([:theme, :support, :svg],        'Experimental Support For SVG',       true),
        S.new([:theme, :support, :webkit],     'Experimental Support For WebKit',    false)
      ].each do |s|
        s.scope = s.scope.join Setting::SCOPE_GLUE
        setting = Setting.first_or_create :scope => s.scope
        setting.update_attributes :name => s.name, :value => s.value if setting.new?
      end

      puts 'Default settings have been loaded'
    end

    desc 'Enables minimum Addons for a functional site'
    task :enable_minimum_addons => :environment do
      [
        :default,
        :default_admin,
      ].each { |theme| ScratchPad::Addon::Theme[theme].enable }

      [
        :branding,
        :copyright,
        :flash,
        :system_menu,
        :yielder
      ].each { |widget| ScratchPad::Addon::Widget[widget].enable }

      l = ScratchPad::Addon::Theme[:default].default_layout
      l.region(:branding).widgets << ScratchPad::Addon::Widget[:branding]
      l.region(:main_menu).widgets << ScratchPad::Addon::Widget[:system_menu]
      l.region(:flash).widgets << ScratchPad::Addon::Widget[:flash]
      l.region(:content).widgets << ScratchPad::Addon::Widget[:yielder]
      l.region(:credits).widgets << ScratchPad::Addon::Widget[:copyright]
      l.save

      l = ScratchPad::Addon::Theme[:default_admin].default_layout
      l.region(:branding).widgets << ScratchPad::Addon::Widget[:branding]
      l.region(:main_menu).widgets << ScratchPad::Addon::Widget[:system_menu]
      l.region(:flash).widgets << ScratchPad::Addon::Widget[:flash]
      l.region(:content).widgets << ScratchPad::Addon::Widget[:yielder]
      l.save

      puts 'Minimum Addons have been enabled. You may disable these later if you have a suitable replacement'
    end

    desc 'Adds the required users'
    task :users => [:environment, :groups] do
      anon = User.first_or_new :username => 'anon', :name => 'Anonymous', :email => 'anonymous@example.com'
      anon.password = User.new_password(24)
      anon.groups << Group.first(:code => :locked)
      anon.save :validate => false

      root = User.first_or_new :username => 'root', :name => 'Administrator', :email => 'root@example.com'
      if root.new?
        root.password = root_password = User.new_password
        puts_loud "The root password was set to #{root_password}. There is no way to recover this, so be sure to store it securely."
      end
      root.groups << Group.first(:code => :root)
      root.save :validate => false

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
      puts_table ScratchPad::Addon::Filter.all, [:name, :machine_name, :enabled?], 'Filters'
      puts
    end

    desc 'List NodeExtensions with a usage count'
    task :node_extensions => :environment do
      puts_table ScratchPad::Addon::NodeExtension.all, [:name, :machine_name, :enabled?], 'Node Extensions'
      puts
    end

    desc 'List Widgets'
    task :widgets => :environment do
      puts_table ScratchPad::Addon::Widget.all, [:name, :machine_name, :enabled?], 'Widgets'
      puts
    end

    desc 'List Themes with status grouped by frontend/backend'
    task :themes => :environment do
      puts_table ScratchPad::Addon::Theme.frontend, [:name, :machine_name, :enabled?], 'Frontend Themes'
      puts
      puts_table ScratchPad::Addon::Theme.backend, [:name, :machine_name, :enabled?], 'Backend Themes'
      puts
    end

    namespace :themes do
      desc 'Set a Theme as active. Useful for emergency recovery from a broken Theme'
      task :activate, :backend_or_frontend, :theme, :needs => :environment do |t, args|
        args.with_defaults :backend_or_frontend => :frontend
        args.with_defaults :theme => (args[:backend_or_frontend].to_sym == :backend ? :default_admin : :default)
        setting = Setting.first_in_scope :theme, args[:backend_or_frontend]
        if setting
          theme = ScratchPad::Addon::Theme[args[:theme]]
          puts "Setting #{args[:backend_or_frontend]} theme to #{theme.title}"
          theme.enable
          setting.update_attributes :value => theme.machine_name
        end
      end
    end
  end
end
