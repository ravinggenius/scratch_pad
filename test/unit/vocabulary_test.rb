require 'test_helper'

class VocabularyTest < ActiveSupport::TestCase
  setup do
    @v = Vocabulary.first_or_create(:code => 'test', :name => 'Code')
  end

  test 'expected api' do
    assert_class_api Vocabulary
    assert_instance_api Vocabulary, :code, :code=, :name, :name=, :terms
  end
end
