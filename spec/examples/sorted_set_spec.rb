require File.dirname(__FILE__) + '/../spec_helper'

describe Likewise::SortedSet do

  before :each do
    Likewise::clear
  end

  it 'should start off empty' do
    list = Likewise::SortedSet.new
    list.should be_empty
  end

  it 'should be able to increment a node' do
    list = Likewise::SortedSet.new
    list.increment Likewise::Node.create
    list.length.should == 1
  end

  it 'should be able to increment several nodes' do
    list = Likewise::SortedSet.new
    2.times do
      list.increment Likewise::Node.create
    end
    list.length.should == 2
  end

  it 'should return the new weight of something when incrementing it' do
    list = Likewise::SortedSet.new
    weight = list.increment Likewise::Node.create
    weight.should == 1
  end

  it 'should increase weight when adding the same node twice' do
    list = Likewise::SortedSet.new
    node = Likewise::Node.create
    2.times do |i|
      list.increment(node).should == i + 1
    end
    list.length.should == 1
  end

  it 'should be able to add things out of order and have them move around' do
    list = Likewise::SortedSet.new
    node1 = Likewise::Node.create
    node2 = Likewise::Node.create
    list.increment(node1)
    list.increment(node2)
    list.increment(node2)
    list.to_a.should == [node2, node1]
  end

  it 'should add new things at the first place they can go' do
    list = Likewise::SortedSet.new
    list.increment Likewise::Node.create
    list.increment (node = Likewise::Node.create)
    list.first.should == node
  end

  it 'should record incremented weight' do
    list = Likewise::SortedSet.new
    node = Likewise::Node.create
    list.increment node
    list.first.context[:weight].should == 1
    list.increment node
    list.first.context[:weight].should == 2
  end

  it 'should let one thing gain on another' do
    list = Likewise::SortedSet.new
    node1 = Likewise::Node.create
    node2 = Likewise::Node.create
    5.times { list.increment(node1) }
    7.times { list.increment(node2) }
    list.first.context[:weight].should == 7
    list.first.should == node2
  end

  it 'should keep the link structure intact across many writes' do
    list = Likewise::SortedSet.new
    10.times { list.increment(Likewise::Node.create) }
    count = 0
    list.send(:each_link) { |l| count += 1 }
    count.should == 10
  end

  it 'should be okay with getting smaller increments later' do
    list = Likewise::SortedSet.new
    node1 = Likewise::Node.create
    list.increment node1
    list.increment node1
    node2 = Likewise::Node.create
    list.increment node2
    list.to_a.should == [node1, node2]
  end

  it 'should let things rearrange order backwards' do
    set = Likewise::SortedSet.new
    node1 = Likewise::Node.create
    node2 = Likewise::Node.create
    2.times { set.increment(node1) }
    3.times { set.increment(node2) }
    set.to_a.should == [node2, node1]
    2.times { set.increment(node1) }
    set.to_a.should == [node1, node2]
  end

  describe :increment_by do

    it 'should be able to increment by more than one' do
      set = Likewise::SortedSet.new
      node1 = Likewise::Node.create
      node2 = Likewise::Node.create
      set.increment_by node1, 2
      set.increment_by node2, 3
      set.to_a.should == [node2, node1]
      set.first.context[:weight].should == 3
    end

    it 'should return resultant weight' do
      set = Likewise::SortedSet.new
      set.increment_by((node = Likewise::Node.create), 1).should == 1
      set.increment_by((node), 2).should == 3
    end

    it 'should raise an error with a negative weight' do
      set = Likewise::SortedSet.new
      lambda do
        set.increment_by Likewise::Node.create, -1
      end.should raise_error ArgumentError
    end

  end

  describe :decrement do

    it 'should affect the local weight' do
      set = Likewise::SortedSet.new
      node1 = Likewise::Node.create
      set.increment node1
      set.decrement node1
      set.first.context[:weight].should == 0
    end

    it 'should affect the total_weight' do
      set = Likewise::SortedSet.new
      node1 = Likewise::Node.create
      set.increment_by node1, 2
      set.decrement node1
      set.total_weight.should == 1
    end

    it 'should reorder based on decrement' do
      set = Likewise::SortedSet.new
      set.increment_by (node1 = Likewise::Node.create), 4
      set.increment_by (node2 = Likewise::Node.create), 3
      set.to_a.should == [node1, node2]
      set.decrement node1
      set.decrement node1
      set.to_a.should == [node2, node1]
    end

    it 'should keep the same set length' do
      set = Likewise::SortedSet.new
      node = Likewise::Node.create
      set.increment node
      set.decrement node
      set.length.should == 1
    end

    it 'should return the resultant weight' do
      set = Likewise::SortedSet.new
      node = Likewise::Node.create
      set.increment(node).should == 1
      set.decrement(node).should == 0
    end

  end

  describe :decrement_by do

    it 'should return the weight' do
      set = Likewise::SortedSet.new
      node = Likewise::Node.create
      set.decrement_by(node, 2).should == -2
    end

    it 'should be able to adjust sort' do
      set = Likewise::SortedSet.new
      set.decrement_by (node1 = Likewise::Node.create), 3
      set.decrement_by (node2 = Likewise::Node.create), 2
      set.to_a.should == [node2, node1]
    end

    it 'should raise an error with negative weight' do
      set = Likewise::SortedSet.new
      lambda do
        set.decrement_by Likewise::Node.create, -1
      end.should raise_error ArgumentError
    end

  end

  describe :set do

    it 'should return the weight' do
      set = Likewise::SortedSet.new
      set.set(Likewise::Node.create, 2).should == 2
    end

    it 'should be able to set multiple and query them in order' do
      set = Likewise::SortedSet.new
      set.set (node1 = Likewise::Node.create), 2
      set.set (node2 = Likewise::Node.create), 4
      set.to_a.should == [node2, node1]
    end

    it 'should affect local weight' do
      set = Likewise::SortedSet.new
      set.set (node1 = Likewise::Node.create), 2
      set.first.context[:weight].should == 2
    end

    it 'should affect total weight' do
      set = Likewise::SortedSet.new
      set.set (node1 = Likewise::Node.create), 2
      set.total_weight.should == 2
    end

    it 'should affect length' do
      set = Likewise::SortedSet.new
      set.set (node1 = Likewise::Node.create), 2
      set.length.should == 1
    end

  end

  describe :remove do

    it 'should remove the node' do
      set = Likewise::SortedSet.new
      set.increment (node = Likewise::Node.create)
      set.remove node
      set.to_a.should == []
    end

    it 'should return the node (with context)' do
      set = Likewise::SortedSet.new
      set.increment (node = Likewise::Node.create)
      ret = set.remove(node)
      ret.should == node
      ret.context.should_not be_nil
    end

    it 'should decrease the memoized length' do
      set = Likewise::SortedSet.new
      ret = set.increment (node = Likewise::Node.create)
      set.remove node
      set.length.should == 0
    end

    it 'should decrease the memoized total weight' do
      set = Likewise::SortedSet.new
      ret = set.increment (node = Likewise::Node.create)
      set.remove node
      set.total_weight.should == 0
    end

  end

end
