namespace :dev do
  desc 'Truncate database, install ScratchPad and set root user\'s password to something easy for development'
  task :reset, :root_password, :needs => :environment do |t, args|
    Rake::Task['db:clear'].invoke
    Rake::Task['sp:install'].invoke
    Rake::Task['dev:root'].invoke args[:root_password]
  end

  desc 'Set root user\'s password to something easy for development'
  task :root, :root_password, :needs => :environment do |t, args|
    args.with_defaults :root_password => 123

    puts "Setting root password to #{args[:root_password]}"
    r = User.root
    r.password = args[:root_password]
    r.save :validate => false
  end
end
