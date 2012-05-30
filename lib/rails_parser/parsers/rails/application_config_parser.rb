module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Rails #:nodoc:
      # = Gemfile Parser
      #
      # The class inspects an application.rb config file and extracts the options
      #
      # It works like this:
      # parser = ApplicationConfigParser.new 
      # parser.parse("/path/to/application.rb")
      # parser.application_name  #=> "Foobar"
      
      class ApplicationConfigParser < RailsParser::Parsers::BaseParser
        
        attr_reader :application_name
        attr_reader :configuration
    
        def initialize
          super
        end
        
        def process_module(exp)
          @application_name = exp[1].to_s
          process(exp[2])
          exp
        end
      
        def process_class(exp)
          class_name = exp[1]
          parent_class = exp[2]
          
          if parent_class && parent_class[1][1] == :Rails && parent_class[2] == :Application
            parser = ConfigParser.new
            parser.process(exp)
            @configuration = parser.configuration
          end
          
          exp
        end
      end
    end
  end
end