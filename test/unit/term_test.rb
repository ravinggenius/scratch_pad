require 'test_helper'

class TermTest < ActiveSupport::TestCase
  setup do
    @c = Term.first_or_create(:name => 'test')
  end

  test 'expected api' do
    expected_class_api Term
    expected_instance_api Term, :name, :name=, :vocabulary, :vocabulary=
  end
end
