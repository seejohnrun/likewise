require 'dalli'

module Likewise

  module Store

    # TODO make marshall confiruably swapped out for JSON
    # A store for putting things into Memcache
    class Memcache

      def initialize(client = nil)
        @client ||= Dalli::Client.new('localhost:11211')
      end

      # Get many keys at once and map them back
      def multiget(keys)
        data = @client.get_multi(keys)
        keys.map { |k| Marshal.load data[k] }
      end

      def set(key, value)
        @client.set key, Marshal.dump(value)
      end

      def get(key)
        if val = @client.get(key)
          Marshal.load(val)
        end
      end

      def clear
        @client.flush
      end

    end

  end

end
