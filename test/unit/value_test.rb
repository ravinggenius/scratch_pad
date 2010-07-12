require 'test_helper'

class ValueTest < ActiveSupport::TestCase
  setup do
    @v = Value.first_or_create(:value => 'foobar')
  end

  test 'expected api' do
    assert_class_api Value
    assert_instance_api Value, :creator
  end

  test 'static methods' do
  end
end
