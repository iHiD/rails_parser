module RailsAuditor #:nodoc:
  class GemfileAuditor
    class GemSpecification
      
      attr_reader :name, :version
      
      def initialize(name, options = {})
        @name = name
        @version = options[:version]
      end
      
      def ==(other_gem)
        return name == other_gem.name
      end
      
    end
  end
end