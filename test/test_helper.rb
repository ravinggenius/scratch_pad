ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...

  def expected_class_api(klass, *methods)
    methods.each { |method| assert klass.respond_to?(method), "#{klass.name} does not respond to :#{method}" }
  end

  def expected_instance_api(klass, *methods)
    k = klass.new
    methods.each { |method| assert k.respond_to?(method), "#{klass.name}.new does not respond to :#{method}" }
  end
end
