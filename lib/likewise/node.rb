require 'uuid'

module Likewise

  class Node

    def self.find(id)
      if data = Likewise::get(id)
        node = new(data)
        node.instance_variable_set(:@id, id)
        node.send(:persisted!)
        node
      end
    end
    
    def self.create(data = {})
      node = new(data)
      node.save
    end

    attr_reader :id

    def ==(node)
      node.id == id
    end

    def hash
      node.id.hash
    end
   
    def []=(key, value)
      unless @data[key] == value
        @data[key] = value
        save
      end
    end

    def [](key)
      @data[key]
    end

    def persisted?
      !!@persisted
    end

    def save
      @id ||= UUID.new.generate
      Likewise::set(@id, @data)
      persisted!
      self
    end

    def initialize(data = {})
      @data = data
    end

    private
 
    def persisted!
      @persisted = true
    end

  end

end
