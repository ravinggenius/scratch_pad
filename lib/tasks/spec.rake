# adapted from https://github.com/rspec/rspec-rails/blob/master/lib/rspec/rails/tasks/rspec.rake

require 'rspec/core'
require 'rspec/core/rake_task'

spec_prereq = Rails.configuration.generators.options[:rails][:orm] == :active_record ?  'db:test:prepare' : :noop

def addon_types
  [
    :addon_base,
    :filter,
    :node_extension,
    :theme,
    :widget
  ]
end

task :noop do
end

namespace :spec do
  desc 'Run the code examples in spec/addons'
  task :addons do
    addon_types.each do |addon_type|
      Rake::Task["spec:addons:#{addon_type}"].invoke
    end
  end

  namespace :addons do
    addon_types.each do |addon_type|
      desc "Run the code examples in spec/addons/#{addon_type}"
      RSpec::Core::RakeTask.new(addon_type => spec_prereq) do |t|
        t.pattern = "./spec/addons/#{addon_type}_spec.rb"
      end
    end
  end
end
