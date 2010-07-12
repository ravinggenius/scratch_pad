require 'test_helper'

class ClassA
  extend Relationship
  habtm :class_as, :class_bs, :class_glue
end

class ClassGlue
  extend Relationship
  habtm_glue :class_a, :class_b
end

class ClassB
  extend Relationship
  habtm :class_bs, :class_as, :class_glue
end

class RelationshipTest < ActiveSupport::TestCase
  setup do
    @a = ClassA.first_or_create
    @b = ClassB.first_or_create
  end

  test 'expected api' do
    @a.class_bs << ClassB.new
    @a.class_bs << ClassB.new
    @a.class_bs << ClassB.new
    @a.save
    assert_equal 3, ClassA.first.class_bs.count

    @b.class_as << ClassA.new
    @b.class_as << ClassA.new
    @b.save
    assert_equal 2, ClassB.first.class_as.count

    assert_equal 3, ClassA.class_bs_for(@a.id)
    assert_equal 2, ClassB.class_as_for(@b.id)

    assert_equal 5, ClassGlue.count
  end
end
