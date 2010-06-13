require 'test_helper'

class TermTest < ActiveSupport::TestCase
  setup do
    @t = Term.first_or_create(:name => 'test')
  end

  test 'expected api' do
    assert_class_api Term
    assert_instance_api Term, :name, :name=, :vocabulary, :vocabulary=
  end
end
