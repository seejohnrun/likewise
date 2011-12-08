require 'uuid'

module Likewise

  class Node

    def self.find(id)
      if data = Likewise::get(id)
        new(id, data)
      end
    end
    
    def self.create(id, data)
      node = Likewise::Node.new(id, data)
      node.save
    end

    attr_reader :id

    def initialize(id = nil, data = {})
      @id = id || UUID.new.generate
      @data = data
    end
    
    def []=(key, value)
      @data[key] = value
      save
    end

    def [](key)
      @data[key]
    end

    def persisted?
      !!@persisted
    end

    def save
      Likewise::set(id, @data)
      persisted!
      self
    end

    private

    def persisted!
      @persisted = true
    end

  end

end
