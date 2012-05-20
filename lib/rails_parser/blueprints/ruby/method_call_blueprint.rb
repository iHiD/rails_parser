module RailsParser #:nodoc:
  module Blueprints #:nodoc:
    module Ruby
      class MethodCallBlueprint
      
        attr_reader :name, :arguments
      
        def initialize(name, options = {})
          @name = name
          @arguments = options[:arguments]
        end
      end
    end
  end
end