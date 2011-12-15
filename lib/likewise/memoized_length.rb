module Likewise

  module MemoizedLength

    def length
      self[:length] || 0
    end

    private

    def element_removed!
      self[:length] = length - 1
    end

    def element_added!
      self[:length] = length + 1
    end

  end

end
