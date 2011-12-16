module Likewise

  class Link < Node

    # TODO more memoization - even of next and prev inside of #next
    # TODO avoid changing to things that are already true

    # Get the next node, or nil if none
    def next
      if self[:next_id]
        Likewise::Link.find_by_id self[:next_id]
      end
    end

    # Get the prev node, or nil if none
    def prev
      if self[:prev_id]
        Likewise::Link.find_by_id self[:prev_id]
      end
    end

    # Get the next id, or nil if none
    def next_id
      self[:next_id]
    end

    # Get the prev id, or nil if none
    def prev_id
      self[:prev_id]
    end

    # Set the next for this link
    def next=(link)
      self[:next_id] = link.nil? ? nil : link.id
    end

    # Set the prev for this link
    def prev=(link)
      self[:prev_id] = link.nil? ? nil : link.id
    end

    # Set the next_id for this link
    def next_id=(id)
      self[:next_id] = id
    end

    # Set the prev_id for this link
    def prev_id=(id)
      self[:prev_id] = id
    end

  end

end
