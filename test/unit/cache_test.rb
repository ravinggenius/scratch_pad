require 'test_helper'

class CacheTest < ActiveSupport::TestCase
  setup do
    @c = Cache.first_or_create(:key => 'test', :value => 'foobar')
  end

  test 'expected api' do
    assert_class_api Cache, :[]
    assert_instance_api Cache, :key, :key=, :value, :value=, :created_at, :updated_at
  end

  test 'static methods' do
    assert_nil Cache[:otter].value
    assert_equal @c.value, Cache[:test].value
    assert_nil Cache[:dove].value
    Cache[:dove].value = 'bird or soap?'
    assert_equal 'bird or soap?', Cache[:dove].value
    assert_nil Cache[:otter].value
  end

  test 'only create need caches' do
    assert_equal 1, Cache.all(:key => 'test').count
  end
end
