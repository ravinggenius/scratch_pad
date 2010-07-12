require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  setup do
    @o = Option.first_or_create(:code => 'foobar')
  end

  test 'expected api' do
    assert_class_api Option
    assert_instance_api Option, :code, :code=, :name, :name=
  end

  test 'static methods' do
  end
end
