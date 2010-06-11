require 'test_helper'

class VocabularyTest < ActiveSupport::TestCase
  setup do
    @v = Vocabulary.first_or_create(:code => 'test', :name => 'Code')
  end

  test 'expected api' do
    expected_class_api Vocabulary
    expected_instance_api Vocabulary, :code, :code=, :name, :name=, :terms
  end
end
