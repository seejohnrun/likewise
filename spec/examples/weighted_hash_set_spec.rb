require File.dirname(__FILE__) + '/../spec_helper'

describe Likewise::WeightedHashSet do

  it 'should be able to add a key' do
    set = Likewise::WeightedHashSet.new
    set.increment Likewise::Node.create
    set.length.should == 1
  end

  describe 'when incrementing an existing key' do
    
    before :each do
      @set = Likewise::WeightedHashSet.new
      @node = Likewise::Node.create
      2.times do
        @set.increment @node
      end
    end

    it 'should still have one key' do
      @set.length.should == 1
    end

    it 'should have an appropriate node weight' do
      @set.first.context[:weight].should == 2
    end

    it 'should have an appropriate set weight' do
      @set.total_weight.should == 2
    end

  end

  describe 'when incrementing different keys' do

    before :each do
      @set = Likewise::WeightedHashSet.new
      @set.increment (@node1 = Likewise::Node.create)
      @set.increment (@node2 = Likewise::Node.create)
    end

    it 'should have an appropriate set length' do
      @set.length.should == 2
    end

    it 'should have an appropriate set weight' do
      @set.total_weight.should == 2
    end

    it 'should have appropriate node weights' do
      @set.first(2).each do |node|
        node.context[:weight].should == 1
      end
    end

  end

end
