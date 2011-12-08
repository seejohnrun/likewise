module Likewise

  # structures
  autoload :LinkedList, 'likewise/structures/linked_list'

  # classes we need
  autoload :Node, 'likewise/node'

  # by default, likewise will use a memory store
  # TODO write this
  class << self

    def get(id)
      hash[id]
    end

    def set(id, value)
      hash[id] = value
    end

    def clear
      @hash = {}
    end

    private

    def hash
      @hash ||= {}
    end

  end

end
