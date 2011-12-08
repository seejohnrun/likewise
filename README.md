# Likewise

At its base, Likewise is a set of data structure implementations designed to sit on top of a distributed Key/Value store.

## LinkedList

``` ruby
list = Likewise::LinkedList.new
list.add Likewise::Node.create('123', :some => 'data')
list.length # 1
list.each do |node|
	node[:some] # "data"
end
```
