# Likewise

At its base, Likewise is a set of data structure implementations designed to sit on top of a distributed Key/Value store.

## LinkedList

``` ruby
list = Likewise::LinkedList.new
list.add Likewise::Node.create(:some => 'data')
list.length # 1
list.each do |node|
	node[:some] # "data"
end
```

## SortedSet

``` ruby
set = Likewise::SortedSet.new
node1 = Likewise::Node.create
node2 = Likewise::Node.create
set.increment node1
set.increment node2
set.increment node2
set.to_a.should == [node2, node1]
```
