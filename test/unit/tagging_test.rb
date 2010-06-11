require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  setup do
    @t = Tagging.first_or_create({})
  end

  test 'expected api' do
    expected_class_api Tagging, :nodes_for, :terms_for
    expected_instance_api Tagging, :node, :node=, :term, :term=
  end
end
