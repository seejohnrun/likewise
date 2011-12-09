module Likewise

  module Collection

    # Empty implementation
    def empty?
      length == 0
    end

    # Return the link for a given node
    def link_for(node)
      each_link { |link| return link if link[:ref_id] == node.id }
      nil
    end

    # A base, iterating approach to length
    # Complexity: O(N)
    def length
      count = 0
      each_link { |n| count += 1 }
      count
    end

    # Get the first element of the Collection
    def first(n = nil)
      res = []
      i = 0
      each_link do |link|
        node = Likewise::Node.find(link[:ref_id])
        node.link = link
        res << node
        break if n.nil? || (i += 1) >= n
      end
      n.nil? ? res.first : res
    end

    # Convert the list into an Array
    # Complexity: O(N)
    def to_a
      arr = []
      each { |n| arr << n }
      arr
    end

    # Yield each of the referenced nodes
    # Complexity: O(N)
    def each(&block)
      each_link do |link|
        yield Likewise::Node.find link[:ref_id]
      end
      self
    end

    private

    # Yield each link
    # Complexity: O(N)
    def each_link(&block)
      next_id = self[:head_id]
      while next_id && node = Likewise::Node.find(next_id)
        yield node
        next_id = node[:next_id]
      end
      self
    end

  end

end
