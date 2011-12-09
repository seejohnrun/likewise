module Likewise

  module MemoizedTotalWeight

    def total_weight
      self[:total_weight] || 0
    end

    private

    def element_incremented!
      self[:total_weight] = total_weight + 1
    end

  end

end
