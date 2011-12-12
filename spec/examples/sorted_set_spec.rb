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
    list.first.link[:weight].should == 1
    list.increment node
    list.first.link[:weight].should == 2
  end

  it 'should let one thing gain on another' do
    list = Likewise::SortedSet.new
    node1 = Likewise::Node.create
    node2 = Likewise::Node.create
    5.times { list.increment(node1) }
    7.times { list.increment(node2) }
    list.first.link[:weight].should == 7
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

end
