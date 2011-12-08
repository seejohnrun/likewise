require File.dirname(__FILE__) + '/../spec_helper'

describe Likewise::LinkedList do

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
    node = Likewise::Node.create nil, :some => 'data'
    list.add(node)
    list.length.should == 1
  end

  it 'should be able to add multiple nodes' do
    list = Likewise::LinkedList.new
    2.times do
      list.add Likewise::Node.create(nil, :some => 'data')
    end
    list.length.should == 2
  end

  it 'should persist when the first node is added' do
    list = Likewise::LinkedList.new
    list.add Likewise::Node.create(nil, :some => 'data')
    list.should be_persisted
  end

  it 'should be able to reload a linkedlist' do
    list = Likewise::LinkedList.new
    list.add Likewise::Node.create(nil, :some => 'data')
    list = Likewise::LinkedList.find(list.id)
    list.length.should == 1
  end

end
