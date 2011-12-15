module Likewise

  # This structure is just like a regular HashSet, except it keeps weighting for all
  # of its elements, and a total weight for the set
  class WeightedHashSet < Node

    include Collection
    include MemoizedLength
    include MemoizedTotalWeight

    # Add a link to the head of this structure
    # Complexity: O(1)
    # @param [Likewise::Node] node - the node to be added
    # @return [Likewise::WeightedHashSet] self
    def increment(node)
      raise 'Node must be persisted!' unless node.persisted?
      link_id = "link-#{id}-#{node.id}"
      link = Likewise::Node.find_by_id link_id
      # If it is here, bump the weight
      if link
        link[:weight] = (link[:weight] || 0) + 1
      # Otherwise, add it
      else
        link = Likewise::Node.create :ref_id => node.id, :id => link_id, :weight => 1
        unless self[:head_id].nil?
          link[:next_id] = self[:head_id]
        end
        self[:head_id] = link.id
        element_added!
      end
      # Either way, this thing was incremented
      element_incremented!
      # Return self
      self
    end

  end

end
