module Likewise

  # This is an implementation of a SortedSet sitting on top of a 
  # Likewise data store
  # 
  # Order will be constantly maintained as elements are inserted
  # in an ascending manner.
  class SortedSet < Node

    include Collection

    # All a member to the collection
    # If it is already in, increment its weight 
    def increment(node)
      raise 'Node must be persisted!' unless node.persisted?
      # construct a new link
      # TODO can be more efficient
      link = delete(node)
      if link
        link[:weight] += 1
      else
        link = Likewise::Node.create :ref_id => node.id, :weight => 1
      end
      # Keep looking until we find one with weight less than 1
      # Update the weight by one
      prev_link = nil
      the_link = nil
      each_link do |alink|
        # This is the place we want to insert
        if link[:weight] >= alink[:weight]
          the_link = alink
          break
        end
        prev_link = alink
      end
      # If this is the head, we are now the head
      if prev_link.nil?
        self[:head_id] = link.id
        link[:next_id] = the_link.id if the_link
      # Otherwise, just insert us
      else
        prev_link[:next_id] = link.id
        link[:next_id] = the_link.id if the_link
      end
      # Return the new weight
      link[:weight]
    end

    private

    # Remove a given node
    def delete(node)
      prev_link = nil
      each_link do |alink|
        if alink[:ref_id] == node.id
          if prev_link.nil?
            self[:head_id] = alink[:next_id]
          else
            prev_link[:next_id] = alink[:next_id]
          end
          return alink # found it
        end
        prev_link = alink
      end
      nil # not found
    end

  end

end
