# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

# http://stackoverflow.com/questions/5287121/undefined-method-task-using-rake-0-9-0-beta-4#6106931
class Rails::Application
  include Rake::DSL if defined?(Rake::DSL)
end

ScratchPad::Application.load_tasks
