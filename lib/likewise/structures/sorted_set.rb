module Likewise

  # This is an implementation of a SortedSet sitting on top of a 
  # Likewise data store
  # 
  # Order will be constantly maintained as elements are inserted
  # in an ascending manner.
  #
  # On this SortedSet, length is memoized
  # On this SortedSet, total weight is memoized
  class SortedSet < Node

    include Collection
    include MemoizedLength
    include MemoizedTotalWeight

    # All a member to the collection
    # If it is already in, increment its weight 
    def increment(node)
      raise 'Node must be persisted!' unless node.persisted?
      # first find out where it is
      prev_link = nil
      the_link = nil
      each_link do |alink|
        if alink[:ref_id] == node.id
          the_link = alink
          break
        end
        prev_link = alink
      end
      # If we found no link, we'll need to create one
      if the_link.nil?
        the_link = Likewise::Node.create :ref_id => node.id, :weight => 1
        prev_link = nil
        element_added!
      else
        the_link[:weight] += 1
      end
      # NOTE: if this was doubly linked we could start moving from here instead for a nice boost
      # Now, given that weight find our where it should be
      prev_dest = nil
      the_dest = nil
      each_link do |alink|
        if the_link[:weight] >= alink[:weight]
          the_dest = alink
          break
        end
        prev_dest = alink
      end
      # If its in the wrong place, time to move it
      unless the_dest == the_link
        # And then we can remove it from where it was
        if prev_link
          prev_link[:next_id] = the_link[:next_id]
        end
        # And put it in its new home
        if prev_dest.nil?
          self[:head_id] = the_link.id  
          the_link[:next_id] = the_dest ? the_dest.id : nil
        else
          prev_dest[:next_id] = the_link.id
          the_link[:next_id] = the_dest ? the_dest.id : nil
        end
      end
      # Return the weight
      element_incremented!
      the_link[:weight]
    end

  end

end
