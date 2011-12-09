require 'forwardable'

module Likewise

  # structures
  autoload :LinkedList, 'likewise/structures/linked_list'
  autoload :SortedSet, 'likewise/structures/sorted_set'

  # classes we need
  autoload :VERSION, 'likewise/version'
  autoload :Collection, 'likewise/collection'
  autoload :MemoizedLength, 'likewise/memoized_length'
  autoload :MemoizedTotalWeight, 'likewise/memoized_total_weight'
  autoload :Node, 'likewise/node'

  # stores
  module Store
    autoload :Memory, 'likewise/store/memory'
    autoload :Memcache, 'likewise/store/memcache'
  end

  # by default, likewise will use a memory store
  class << self

    extend Forwardable

    def_delegators :store, :get, :set, :clear

    attr_writer :store

    def store
      @store ||= Store::Memory.new
    end

  end

end
