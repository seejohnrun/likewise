module Likewise

  # This is an implementation of a LinkedList sitting on top of a
  # Likewise data store.
  #
  # This implementation memoizes length on the head element for O(1)
  # performance on #length
  class LinkedList < Node

    include Collection

    # Add a link to the end of this structure that references this node
    # Complexity: O(N)
    def add(node)
      raise 'Node must be persisted!' unless node.persisted?
      # Traverse to the end
      last_link = nil
      each_link do |link|
        last_link = link
      end
      # Create a new link
      # If there is no last node, make the link the head
      # Otherwise, throw the link at the end
      link = Likewise::Node.create :ref_id => node.id
      if last_link.nil?
        self[:head_id] = link.id
      else
        last_link[:next_id] = link.id
      end
      # Increment our length, which is memoized
      self[:length] = (self[:length] || 0) + 1
    end

    # Compute the length by moving through the list
    # Complexity: O(1)
    def length
      self[:length] || 0
    end

    # Convert the list into an Array
    # Complexity: O(N)
    def to_a
      arr = []
      each { |n| arr << n }
      arr
    end

  end

end
