module Likewise

  module Collection

    # A base, iterating approach to length
    # Complexity: O(N)
    def length
      count = 0
      each_link { |n| count += 1 }
      count
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
      while node = Likewise::Node.find(next_id)
        yield node
        next_id = node[:next_id]
      end
      self
    end

  end

end