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
      links = []
      each_link.with_index do |n, i|
        links << n
        break if total.nil? || (i += 1) >= total
      end
      # And now multiget those we want, and return
      nodes = links_to_nodes(links)
      total.nil? ? nodes.first : nodes
    end

    # Convert the list into an Array
    # Complexity: O(N)
    def to_a
      # multiget the nodes, and return
      links_to_nodes(links)
    end

    # Yield each of the referenced nodes
    # Complexity: O(N)
    def each
      return to_enum(:each) unless block_given?
      each_link do |link|
        yield Likewise::Node.find link[:ref_id]
      end
      self
    end

    private

    # Get the links in order
    # @complexity O(N)
    # @return [Array] the resulting links
    def links
      [].tap do |links|
        each_link { |l| links << l }
      end
    end

    # Map a group of links to nodes
    # @param [Array] links - the Links to map to nodes
    # @return The nodes, with links in the #link attributes of each
    def links_to_nodes(links)
      nodes = Likewise::Node.find links.map { |l| l[:ref_id] }
      nodes.each_with_index { |n, idx| n.context = links[idx] }
      nodes
    end

    # Yield each link
    # Complexity: O(N)
    def each_link
      return to_enum(:each_link) unless block_given?
      next_id = self[:head_id]
      while next_id && node = Likewise::Link.find(next_id)
        yield node
        next_id = node[:next_id]
      end
      self
    end

  end

end
