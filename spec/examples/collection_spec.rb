require File.dirname(__FILE__) + '/../spec_helper'

describe Likewise::Collection do

  describe :first do

    # Create a set with two nodes
    before :each do
      @set = Likewise::SortedSet.new
      2.times do
        @set.increment Likewise::Node.create
      end
    end

    it 'should return the top node when no arg is given' do
      @set.first.should be_a Likewise::Node
    end

    it 'should return the top 1 when given 1 as arg' do
      @set.first(1).tap do |nodes|
        nodes.length.should == 1
        nodes.should be_a(Array)
      end
    end

    it 'should return all when given a num > count' do
      @set.first(10).length.should == 2
    end

  end

end
