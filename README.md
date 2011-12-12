# Likewise

At its base, Likewise is a set of data structure implementations designed to sit on top of a distributed Key/Value store.

## Structures

### LinkedList

#### Description

LinkedList which will always append to end and maintain order

#### Example

``` ruby
list = Likewise::LinkedList.new
list.add Likewise::Node.create(:some => 'data')
list.length # 1
list.each do |node|
	node[:some] # "data"
end
```

#### OHHHH

* O(N) insertion

### SortedSet

#### Description

This is a SortedSet implentation on top of a `LinkedList`-type implementation, which gives it a slow insertion speed, but makes looking up the top elements O(1).  This is the desired characteristic.

#### Example

``` ruby
set = Likewise::SortedSet.new
node1 = Likewise::Node.create
node2 = Likewise::Node.create
set.increment node1
set.increment node2
set.increment node2
set.to_a.should == [node2, node1]
```

#### OHHHH

* O(N) on insertion
* O(1) on first

### HashSet

#### Description

This is a HashSet implementation, which uses KV random access for its implementation.

#### Example

``` ruby
set = Likewise::SortedSet.new
node1 = Likewise::Node.create
set.length # 1
```

#### OHHHH

* O(1) on insertion
* O(1) on search
* O(1) on length (due to memoization)

## Storage

### Memory

Memory store stores all nodes in memory.  It is designed for testing, since Likewise isn't very useful for anywhere the problem can live in memory.

It is the default, and you can explicitly set it with: `Likewise::store = Likewise::Store::Memory.new`

### Memcache / Membase

Store your data in Memcache (more preferably Membase).  This really hits at the intended purpose of the library, since we can grow these collections as large as we'd like.

YOu can set it with: `Likewise::store = Likewise::Store::Memcache.new` which will take an optional argument which is a `Dalli` client already connected to the host you'd like.

## Dependencies

* Ruby >= 1.9
