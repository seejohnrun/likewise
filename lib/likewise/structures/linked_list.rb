module Likewise

  # This is an implementation of a LinkedList sitting on top of a
  # Likewise data store.
  #
  # This implementation memoizes length on the head element for O(1)
  # performance on #length
  class LinkedList < Node

    include Collection
    include MemoizedLength

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
      element_added!
    end

    # Remove a node's link from this list (may remove multiple)
    # Complexity: O(N)
    # @param [Likewise::Node] node - the node to be removed
    # @return [Likewise::Node] the node, if removed, nil otherwise
    def remove(node)
      # Traverse looking for the node
      sets = []
      prev_link = nil
      each_link do |link|
        if link[:ref_id] == node.id
          sets << [prev_link, link]
          next # in case adjacent removal node links
        end
        prev_link = link
      end
      # Now we can just do the join and we're out
      sets.each do |prev_link, the_link|
        if prev_link
          prev_link[:next_id] = the_link[:next_id]
        else
          self[:head_id] = the_link[:next_id]
        end
        # Mark removal
        element_removed!
      end
      # Return the node if any were removed
      node unless sets.empty?
    end

  end

end
