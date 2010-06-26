namespace :test do
  desc 'Run custom tests in ./lib. RAILS_ENV needs to be set to test before running'
  task :custom => :environment do
    Dir[Rails.root + 'lib/**/tests/*_test.rb'].each { |path| load path }
  end
end