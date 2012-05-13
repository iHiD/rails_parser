module RailsAuditor #:nodoc:
  module Blueprints #:nodoc:
    class GemfileBlueprint
      attr_reader :gems
    
      def initialize(filepath, gems)
        @filepath = filepath
        @gems     = gems
      end
    end
  end
end
      