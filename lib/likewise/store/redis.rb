require 'redis'

module Likewise

  module Store

    # TODO make marshall confiruably swapped out for JSON
    # A store for putting things into Redis
    class Redis

      def initialize(client = nil)
        @client ||= ::Redis.new
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
        @client.flushdb
      end

    end

  end

end
