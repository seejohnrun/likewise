# Likewise

At its base, Likewise is a set of data structure implementations designed to sit on top of a distributed Key/Value store.

## Structures

### LinkedList

``` ruby
list = Likewise::LinkedList.new
list.add Likewise::Node.create(:some => 'data')
list.length # 1
list.each do |node|
	node[:some] # "data"
end
```

### SortedSet

``` ruby
set = Likewise::SortedSet.new
node1 = Likewise::Node.create
node2 = Likewise::Node.create
set.increment node1
set.increment node2
set.increment node2
set.to_a.should == [node2, node1]
```

## Storage

### Memory

Memory store stores all nodes in memory.  It is designed for testing, since Likewise isn't very useful for anywhere the problem can live in memory.

It is the default, and you can explicitly set it with: `Likewise::store = Likewise::Store::Memory.new`

### Memcache / Membase

Store your data in Memcache (more preferably Membase).  This really hits at the intended purpose of the library, since we can grow these collections as large as we'd like.

YOu can set it with: `Likewise::store = Likewise::Store::Memcache.new` which will take an optional argument which is a `Dalli` client already connected to the host you'd like.

## Dependencies

* Ruby >= 1.9
