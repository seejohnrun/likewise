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

end
