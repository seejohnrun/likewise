module Likewise

  # This is an implementation of a HashSet sitting on top of a Likewise
  # data store.
  #
  # It can abuse the KV properties of the store to get O(1) membership time
  # and, can always insert at the top for O(1) insertion time.
  #
  # This implementation also memoizes #length for O(1) performance
  class HashSet < Node

    include Collection
    include MemoizedLength

    # Add a link to the head of this structure
    # Complexity: O(1)
    # @param [Likewise::Node] node - the Node to be added
    # @return [Likewise::HashSet] self
    def add(node)
      raise 'Node must be persisted!' unless node.persisted?
      # If its here, do nothing - otherwise, add to head
      unless has?(node)
        link_id = "link-#{id}-#{node.id}"
        link = Likewise::Node.create :ref_id => node.id, :id => link_id
        unless self[:head_id].nil?
          link[:next_id] = self[:head_id]
        end
        self[:head_id] = link.id
        element_added!
      end
      # Return self
      self
    end

    # Determine membership
    # Complexity: O(1)
    # @param [Likewise::Node] node - the Node to check for
    # @return [Boolean] whether or not the node is present
    def has?(node)
      !!Likewise::Node.exists?("link-#{id}-#{node.id}")
    end

  end

end
