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
        attr_reader :config_options
    
        def initialize
          super
          self.auto_shift_type = true
        end
        
        def process_module(exp)
          @application_name = exp.shift.to_s
          module_exp = exp.shift
          process(module_exp)
          exp
        end
      
        def process_class(exp)
          class_name = exp.shift
          block_exp = exp.pop
          parent_class = exp.shift
          
          if parent_class && parent_class[1][1] == :Rails && parent_class[2] == :Application
            parser = ConfigParser.new
            parser.process(block_exp)
            @config_options = parser.config_options
          end
          
          exp
        end
      end
    end
  end
end