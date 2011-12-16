module Likewise

  module MemoizedTotalWeight

    def total_weight
      self[:total_weight] || 0
    end

    private

    def element_incremented!(by = 1)
      self[:total_weight] = total_weight + by
    end

    def element_decremented!(by = 1)
      self[:total_weight] = total_weight - by
    end

  end

end
