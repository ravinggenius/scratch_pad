require 'test_helper'

class ClassA
  include MongoMapper::Document
  include Relationship

  key :name, String

  habtm :class_as, :class_bs, :glue_model => :class_glue
end

class ClassGlue
  include MongoMapper::Document
  include Relationship

  habtm_glue :class_a, :class_b
end

class ClassB
  include MongoMapper::Document
  include Relationship

  key :name, String

  habtm :class_bs, :class_as, :glue_model => :class_glue
end

class RelationshipTest < ActiveSupport::TestCase
  setup do
    @a = ClassA.first_or_create :name => 'class a'
    @b = ClassB.first_or_create :name => 'class b'
  end

  test 'expected api' do
    @a.class_bs << ClassB.new
    @a.class_bs << ClassB.new
    @a.class_bs << ClassB.new
    @a.save
    assert_equal 3, ClassA.first(:name => 'class a').class_bs.count

    @b.class_as << ClassA.new
    @b.class_as << ClassA.new
    @b.save
    assert_equal 2, ClassB.first(:name => 'class b').class_as.count

    assert_equal 3, ClassA.class_bs_for(@a.id).count
    assert_equal 2, ClassB.class_as_for(@b.id).count

    assert_equal 5, ClassGlue.count
  end
end
