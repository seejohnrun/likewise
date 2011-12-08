module Likewise

  module Store

    # A store that stays in memory only (ideal for testing)
    class Memory

      # Get set up
      def initialize
        clear
      end

      # Set a key
      def set(key, value)
        @hash[key] = value
      end

      # Get a key
      def get(key)
        @hash[key]
      end

      # Clear everything
      def clear
        @hash = {}
      end

    end

  end

end
