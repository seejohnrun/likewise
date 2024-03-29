require 'uuid'

module Likewise

  class Node

    class << self

      def find_by_id(id)
        if data = Likewise::get(id)
          node = from_hash(data)
          node.instance_variable_set(:@id, id)
          node.send(:persisted!)
          node
        end
      end

      def find_or_create(data)
        raise 'no id' unless data[:id]
        find(data[:id]) || create(data)
      end

      def exists?(id)
        !!Likewise::get(id)
      end

      # Find Nodes
      # @param [Array, String] ids - The id or ids to look up
      # @return [Array, Likewise::Node] nodes - The nodes returned.  Array is ids is Array
      def find(ids)
        if ids.is_a?(Array)
          datum = Likewise::multiget(ids)
          ids.map.with_index do |id, idx|
            node = from_hash(datum[idx])
            node.instance_variable_set(:@id, id)
            node.send(:persisted!)
            node
          end
        else
          data = Likewise::get(ids)
          node = from_hash(data)
          node.instance_variable_set(:@id, ids)
          node.send(:persisted!)
          node
        end
      end

      # Create a new node
      # @param [Hash] data - Metadata for this node (optional)
      # @return [Likewise::Node] the created node
      def create(data = {})
        node = new(data)
        node.instance_variable_set(:@id, data.delete(:id)) if data[:id]
        node.save
      end

    end

    # The ID of this node
    attr_reader :id

    # The link for the given context of this node
    attr_accessor :context

    # Equality is based on node IDs
    def ==(node)
      if node
        node.id == id
      end
    end

    # Hash implemented for equality operation is based on IDs
    def hash
      id.hash
    end
   
    # Set an attribute on this node
    # TODO change out for #meta
    def []=(key, value)
      unless @meta[key] == value
        @meta[key] = value
        save
      end
    end

    # Get an attribute on this node
    # TODO change out for #meta
    def [](key)
      @meta[key]
    end

    # Whether or not this node is currently persisted
    # The way that nodes persist, whenever they have data changed,
    # they will automatically be persisted, so this should only be false
    # when using #new
    # @return [Boolean] whether or not the node is persisted currently
    def persisted?
      !!@persisted
    end

    # Save the given node to the datastore - giving it a new UUID as its
    # id if it doesn't have one already.
    # @return self
    def save
      Likewise::set(@id, to_hash)
      persisted!
      self
    end

    # Initialize a new Node with the given data set
    def initialize(meta = {})
      @id ||= UUID.new.generate
      @meta = meta
    end

    private

    def self.from_hash(hash)
      obj = new
      obj.instance_variable_set :@meta, hash[:meta]
      obj
    end

    def to_hash
      {
        :meta => @meta
      }
    end
 
    # Mark this node as persisted
    def persisted!
      @persisted = true
    end

  end

end
