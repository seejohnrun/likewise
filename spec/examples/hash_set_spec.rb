require File.dirname(__FILE__) + '/../spec_helper'

describe Likewise::HashSet do

  describe :add do

    it 'should be able to add a node' do
      set = Likewise::HashSet.new
      set.add Likewise::Node.create
      set.length.should == 1
    end

    it 'should not add an additional node when adding the same node twice' do
      set = Likewise::HashSet.new
      node = Likewise::Node.create
      2.times { set.add(node) }
      set.length.should == 1
    end

    it 'should add two different nodes' do
      set = Likewise::HashSet.new
      set.add Likewise::Node.create
      set.add Likewise::Node.create
      set.length.should == 2
    end

  end

  describe :has? do

    it 'should be able to tell when it does not have a key' do
      set = Likewise::HashSet.new
      set.has?(Likewise::Node.create).should be false
    end

    it 'should be able to tell when it does have a key' do
      set = Likewise::HashSet.new
      set.add (node = Likewise::Node.create)
      set.has?(node).should be true
    end

  end

end
