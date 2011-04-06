require 'spec_helper'

describe Node do
  describe '#children' do
    subject { Factory.build(:node) }

    after(:each) { Node.delete_all }

    it 'should not have any children by default' do
      subject.children.should be_empty
    end

    it 'should allow a child to be added' do
      subject.children << Factory.build(:node)
      subject.children.length.should == 1
      subject.children << Factory.build(:node)
      subject.children.length.should == 2
      subject.save
      Node.count.should == 3
    end

    it 'should allow the same child to be added twice' do
      child = Factory.build(:another_node)
      child.save
      subject.children = [child, child]
      subject.save
      Node.count.should == 2
      Node.first(:title => subject.title).children.length.should == 2
    end

    it 'should allow mass children assignment' do
      subject.children = [Factory.build(:node), Factory.build(:node)]
      subject.children.length.should == 2
      subject.save
      Node.count.should == 3
    end
  end

  describe '#children?' do
    it 'should be true only when children are present' do
      Node.new.children?.should be_false
      Node.new(:children => [Node.new]).children?.should be_true
    end
  end
end
