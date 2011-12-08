module Likewise

  # This is an implementation of a LinkedList sitting on top of a
  # Likewise data store.
  class LinkedList < Node

    # Empty if the length is 0
    # Complexity: O(1)
    def empty?
      length == 0
    end

    # Add a link to the end of this structure that references this node
    # Complexity: O(N)
    def add(node)
      raise 'Node must be persisted!' unless node.persisted?
      # Traverse to the end
      last_link = nil
      each do |link|
        last_link = link
      end
      # Create a new link
      # If there is no last node, make the link the head
      # Otherwise, throw the link at the end
      link = Likewise::Node.new nil, :ref => node.id
      link.save
      if last_link.nil?
        @head_id = link.id
        save
      else
        last_link[:next_id] = link.id
        last_link.save
      end
      # Increment our length, which is memoized
      self[:length] = (self[:length] || 0) + 1
      save
    end

    # Compute the length by moving through the list
    # Complexity: O(1)
    def length
      self[:length] || 0
    end

    # Go through and yield each link
    # Complexity: O(N)
    def each(&block)
      next_id = @head_id
      while node = Likewise::Node.find(next_id)
        yield node
        next_id = node[:next_id]
      end
      self
    end

  end

end
