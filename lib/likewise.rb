module Likewise

  # structures
  autoload :LinkedList, 'likewise/structures/linked_list'
  autoload :SortedSet, 'likewise/structures/sorted_set'

  # classes we need
  autoload :VERSION, 'likewise/version'
  autoload :Collection, 'likewise/collection'
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
