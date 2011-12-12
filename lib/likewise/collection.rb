module Likewise

  module Collection

    # Empty implementation
    def empty?
      length == 0
    end

    # A base, iterating approach to length
    # Complexity: O(N)
    def length
      count = 0
      each_link { |n| count += 1 }
      count
    end

    # Get the first element of the Collection
    def first(total = nil)
      i = 0
      links = []
      each_link do |n|
        links << n
        break if total.nil? || (i += 1) >= total
      end
      # And now multiget those we want
      nodes = Likewise::Node.find links.map { |l| l[:ref_id] }
      nodes.each_with_index { |n, i| n.link = links[i] }
      # And return
      total.nil? ? nodes.first : nodes
    end

    # Convert the list into an Array
    # Complexity: O(N)
    def to_a
      # Grab the links in order
      links = []
      each_link { |n| links << n }
      # And now multiget the nodes
      nodes = Likewise::Node.find links.map { |l| l[:ref_id] }
      nodes.each_with_index { |n, i| n.link = links[i] }
      # And return the nodes
      nodes
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
