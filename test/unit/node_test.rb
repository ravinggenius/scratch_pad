require 'test_helper'

class TempNode < Node
end

class NodeTest < ActiveSupport::TestCase
  setup do
    @n = TempNode.first_or_create(:title => 'Test Node')
  end

  test 'expected api' do
    expected_class_api TempNode, :published
    expected_instance_api TempNode, :is_published, :name, :name=, :position, :position=, :created_at, :updated_at, :children, :terms, :machine_name
  end

  test 'aliases' do
    assert_equal @n.title, @n.name
    @n.name = 'Another Title'
    assert_equal @n.name, @n.title

    assert_equal @n.creator.id, @n.author.id
    assert_equal @n.updater.id, @n.editor.id
  end

  test 'machine name' do
    assert_equal 'temp_node', @n.machine_name
  end
end
