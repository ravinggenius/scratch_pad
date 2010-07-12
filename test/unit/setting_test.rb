require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  setup do
    @s = Setting.first_or_create(:code => 'test', :value => 'foobar')
  end

  test 'expected api' do
    assert_class_api Setting, :[]
    assert_instance_api Setting, :code, :code=, :name, :name=, :scope, :scope=
  end

  test 'static methods' do
  end
end
