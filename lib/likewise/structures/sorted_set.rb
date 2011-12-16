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

    # Set the weight of a given node
    # @param [Likewise::Node] node - the node to set
    # @param [Fixnum] weight - the weight to set
    # @return [Fixnum] The resultant weight
    def set(node, weight)
      change_by node, nil, weight
    end

    # Increment a node by 1
    # @param [Likewise::Node] node - The Node to increment
    # @return [Fixnum] The resultant weight
    def increment(node)
      change_by node, 1
    end

    # Increment a node by a given value
    # @param [Likewise::Node] node - The node to increment
    # @param [Fixnum] weight - The amount to increment by
    # @return [Fixnum] The resultant weight
    def increment_by(node, weight)
      raise ArgumentError.new('please use #decrement_by') if weight < 0
      change_by node, weight
    end

    # Decrement a node by 1
    # @param [Likewise::Node] node - The Node to decrement
    # @return [Fixnum] The resultant weight
    def decrement(node)
      change_by node, -1
    end

    # Decrement a node by a given value
    # @param [Likewise::Node] node - The node to decrement
    # @param [Fixnum] weight - The amount to decrement by
    # @return [Fixnum] The resultant weight
    def decrement_by(node, weight)
      raise ArgumentError.new('please use #increment_by') if weight < 0
      change_by node, -weight
    end

    private

    # Since a node only appears once we can use this
    # for quick #find
    def key_for(node)
      "#{id}-#{node.id}"
    end

    # All a member to the collection
    # If it is already in, increment its weight 
    # TODO if it doesn't need to move, don't move it
    # @param [Likewise::Node] node - the Node the change
    # @param [Fixnum] by - the amount to change by (may be negative, or nil if set is provided)
    # @param [Fixnum] set - the amount to change to (may be negative, or nil if by is provided)
    # @return [Fixnum] the resultant weight
    def change_by(node, by, set = nil)
      raise 'Node must be persisted!' unless node.persisted?
      # first find out where it is
      the_link = Likewise::Link.find_by_id key_for(node)
      # Allow set to work
      by = the_link.nil? ? set : set - the_link[:weight] if set
      # If we found no link, we'll need to create one
      if the_link.nil?
        the_link = Likewise::Link.create :ref_id => node.id, :weight => by,
          :id => key_for(node)
        element_added!
      else
        the_link[:weight] += by
      end
      # Remove the link
      remove_link the_link
      # Now, given that weight find our where it should be
      the_dest = nil
      last_link = nil
      each_link do |alink|
        if the_link[:weight] >= alink[:weight]
          the_dest = alink
          break
        end
        last_link = alink
      end
      # And put it in its new home
      place_link the_link, the_dest, last_link
      # Return the weight
      element_incremented!(by)
      the_link[:weight]
    end

    # Place a given link in the set just before the dest
    # @param [Likewise::Link] node - the link to palce
    # @param [Likewise::Link] dest - the link to place node before
    def place_link(link, dest, last_link)
      # If there is no dest, we are meant to be 
      if dest.nil?
        # If we have no last link, we are alone - and are head
        # and link's prev remains nil
        if last_link.nil?
          self[:head_id] = link.id
        # If we have the last link, we want to be after it
        else
          last_link.next = link
          link.prev = last_link
        end
      # Otherwise, we want to be at dest
      else
        # If dest has no prev, we'll be it's prev and the head
        if dest.prev_id.nil?
          self[:head_id] = link.id
          link.next = dest
          dest.prev = link
        # Otherwise, squeeze our way in
        else
          link.next = dest
          link.prev = dest.prev
          dest.prev = link
          link.prev.next = link
        end
      end
    end

    # Remove a given link entirely
    # The link MUST exist in the set
    def remove_link(link)
      # If the_link is head, set head to nil
      if self[:head_id] == link.id
        self[:head_id] = link.next_id
      end
      if link.prev
        # If things on both sides, link them
        if link.next
          link.prev.next_id = link.next_id
          link.next.prev_id = link.prev_id 
          link.next = nil
          link.prev = nil
        # If no next id, clear prev's next
        else
          link.prev.next_id = nil
          link.prev = nil
        end
      else
        # If no prev id, clear next's prev
        if link.next
          link.next.prev_id = nil
          link.next = nil
        # It none on either side, do nothing
        else
        end
     end
    end

  end

end
