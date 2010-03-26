# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails.root)
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["./support/**/*.rb"].each {|f| require f}

# Work around rspec not yet being ORM agnostic
DataMapper::Resource.module_eval do
  def has_attribute?(attribute)
    attributes.include?(attribute)
  end
end

Rspec.configure do |config|

  # Remove this line if you don't want Rspec's should and should_not
  # methods or matchers
  require 'rspec/expectations'
  config.include Rspec::Matchers

  config.before(:all) { DataMapper.auto_migrate! }

  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

end
