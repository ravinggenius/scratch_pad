require 'test_helper'

class TempNode < Node
end

class NodeTest < ActiveSupport::TestCase
  setup do
    @n = TempNode.first_or_create(:name => 'Test Node')
  end

  test 'expected api' do
    assert_class_api TempNode, :published
    assert_instance_api TempNode, :is_published, :name, :name=, :position, :position=, :created_at, :updated_at, :children, :terms, :machine_name
  end

  test 'aliases' do
    assert_equal @n.name, @n.title
    @n.name = 'Another Title'
    assert_equal @n.title, @n.name

    assert_equal @n.creator.id, @n.author.id
    assert_equal @n.updater.id, @n.editor.id
  end

  test 'default values' do
    n = TempNode.create(:name => 'Another Test')
    assert !n.is_published
    assert_equal 0, n.position
    assert_equal 0, n.children.count
    assert_equal 0, n.terms.count
  end

  test 'machine name' do
    assert_equal 'temp_node', @n.machine_name
  end

  test 'children' do
    n = TempNode.create(:name => 'Parent Node')
    assert_equal 0, n.children.count
    n.children << TempNode.create(:name => 'Child One')
    n.children << TempNode.create(:name => 'Child Two')
    n.save
    assert_equal 2, TempNode.first(:name => 'Test Node').children.count
  end
end
