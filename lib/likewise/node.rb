require 'uuid'

module Likewise

  class Node

    class << self

      def find_or_create(data)
        raise 'no id' unless data[:id]
        find(data[:id]) || create(data)
      end

      def find(id)
        if data = Likewise::get(id)
          node = new(data)
          node.instance_variable_set(:@id, id)
          node.send(:persisted!)
          node
        end
      end

      def create(data = {})
        node = new(data)
        node.instance_variable_set(:@id, data.delete(:id)) if data[:id]
        node.save
      end

    end

    attr_reader :id
    attr_accessor :link

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
