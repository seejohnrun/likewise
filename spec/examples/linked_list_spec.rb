require File.dirname(__FILE__) + '/../spec_helper'

describe Likewise::LinkedList do

  before :each do
    Likewise::clear
  end

  it 'should start off empty' do
    list = Likewise::LinkedList.new
    list.should be_empty
  end

  it 'should start off not persisted' do
    list = Likewise::LinkedList.new
    list.should_not be_persisted
  end

  it 'should be able to reload a linkedlist' do
    list = Likewise::LinkedList.new
    list.add Likewise::Node.create(:some => 'data')
    list = Likewise::LinkedList.find(list.id)
    list.length.should == 1
  end

  it 'should be able to get each of the original nodes - in order' do
    list = Likewise::LinkedList.new
    nodes = []
    3.times do
      list.add (node = Likewise::Node.create(:some => 'data'))
      nodes << node
    end
    list.to_a.should == nodes
  end

  describe 'add' do

    it 'should be able to add a node' do
      list = Likewise::LinkedList.new
      node = Likewise::Node.create :some => 'data'
      list.add(node)
      list.length.should == 1
    end

    it 'should be able to add multiple nodes' do
      list = Likewise::LinkedList.new
      2.times do
        list.add Likewise::Node.create(:some => 'data')
      end
      list.length.should == 2
    end

    it 'should persist when the first node is added' do
      list = Likewise::LinkedList.new
      list.add Likewise::Node.create(:some => 'data')
      list.should be_persisted
    end

  end

  describe 'remove' do

    it 'should remove an element' do
      list = Likewise::LinkedList.new
      list.add (node = Likewise::Node.create)
      list.remove node
      lambda do
        list.each { |l| fail }
      end.should_not raise_error
    end

    it 'should return the removed node' do
      list = Likewise::LinkedList.new
      list.add (node = Likewise::Node.create)
      list.remove(node).should == node
    end

    it 'should return nil if nothing is removed' do
      list = Likewise::LinkedList.new
      node = Likewise::Node.create
      list.remove(node).should be_nil
    end

    it 'should decrease the length when removing' do
      list = Likewise::LinkedList.new
      list.add (node = Likewise::Node.create)
      list.remove node
      list.length.should == 0
    end

    it 'should be able to remove the head' do
      list = Likewise::LinkedList.new
      list.add (node1 = Likewise::Node.create)
      list.add (node2 = Likewise::Node.create)
      list.add (node3 = Likewise::Node.create)
      list.remove(node1)
      list.to_a.should == [node2, node3]
    end

    it 'should be able to remove a middle element' do
      list = Likewise::LinkedList.new
      list.add (node1 = Likewise::Node.create)
      list.add (node2 = Likewise::Node.create)
      list.add (node3 = Likewise::Node.create)
      list.remove(node2)
      list.to_a.should == [node1, node3]
    end

    it 'should be able to remove the tail' do
      list = Likewise::LinkedList.new
      list.add (node1 = Likewise::Node.create)
      list.add (node2 = Likewise::Node.create)
      list.add (node3 = Likewise::Node.create)
      list.remove(node3)
      list.to_a.should == [node1, node2]
    end

    it 'should remove multiple that are next to each other' do
      list = Likewise::LinkedList.new
      list.add (node2 = Likewise::Node.create)
      list.add (node1 = Likewise::Node.create)
      list.add node1
      list.add node2
      list.remove(node1)
      list.to_a.should == [node2, node2]
    end

    it 'should remove multiple that are at opposite ends of the list' do
      list = Likewise::LinkedList.new
      list.add (node1 = Likewise::Node.create)
      list.add (node2 = Likewise::Node.create)
      list.add node1
      list.remove(node1)
      list.to_a.should == [node2]
    end

  end

end
