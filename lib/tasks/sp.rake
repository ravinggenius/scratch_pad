def password(length = 12)
  alphanumerics = [('0'..'9'), ('A'..'Z'), ('a'..'z')].map { |range| range.to_a }.flatten
  (0...length).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
end

namespace :sp do
  desc 'Sets up users, groups and default settings'
  task :setup do
    Rake::Task['sp:setup:settings'].invoke
  end

  namespace :setup do
    desc 'Initialize settings'
    task :settings => [:environment, :users] do
      [
        { :scope => 'core.templates.active',              :name => 'Frontend Template',                  :value => 'default' },
        { :scope => 'core.templates.active.admin',        :name => 'Backend Template',                   :value => 'default_admin' },
        { :scope => 'core.site.name',                     :name => 'Site Name',                          :value => 'ScratchPad' },
        { :scope => 'core.site.tagline',                  :name => 'Site Tagline',                       :value => '...' },
        { :scope => 'core.user.password.min_length',      :name => 'Minimum Password Length',            :value => 8 },
        { :scope => 'core.styles.experimental.khtml',     :name => 'Experimental Support For KHTML',     :value => false },
        { :scope => 'core.styles.experimental.microsoft', :name => 'Experimental Support For Microsoft', :value => false },
        { :scope => 'core.styles.experimental.mozilla',   :name => 'Experimental Support For Mozilla',   :value => false },
        { :scope => 'core.styles.experimental.opera',     :name => 'Experimental Support For Opera',     :value => false },
        { :scope => 'core.styles.experimental.webkit',    :name => 'Experimental Support For WebKit',    :value => false }
      ].each do |setting|
        v = Value.first_or_new({
          :creator_id => User.anonymous.id,
          :updater_id => User.anonymous.id,
          :value => setting[:value]
        })
        v.setting = Setting.first_or_create(:scope => setting[:scope], :name => setting[:name])
        v.save
      end

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
  end

  desc 'Load the seed data from db/seeds.rb'
  task :seed => [:environment, :users] do
    seed_file = File.join(Rails.root, 'db', 'seeds.rb')
    load seed_file if File.exist? seed_file
    puts 'Database has been seeded'
  end

  desc 'List all Scions, grouped by type'
  task :scions do
    Rake::Task['sp:scions:filters'].invoke
    Rake::Task['sp:scions:node_extensions'].invoke
    Rake::Task['sp:scions:templates'].invoke
  end

  namespace :scions do
    desc 'List Filters with along with the FilterGroups they belong to'
    task :filters => :environment do
      Filter.all.each do |filter|
        puts filter.title
      end
    end

    desc 'List NodeExtensions with a usage count'
    task :node_extensions => :environment do
      NodeExtension.all.each do |extension|
        puts extension.title
      end
    end

    desc 'List Templates with status'
    task :templates => :environment do
      active_template = Setting['core.templates.active'].user_value
      active_admin_template = Setting['core.templates.active.admin'].user_value
      # TODO Template.frontend.each do |template|
      # TODO Template.backend.each do |template|
      Template.all.each do |template|
        puts "#{template.title} is #{template.name == active_template ? 'active' : 'inactive'}"
      end
    end

    namespace :templates do
      desc 'Set a Template as active. Useful for emergency resetting a Template'
      task :activate => :environment do
      end
    end
  end
end
