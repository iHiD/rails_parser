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
      
      class ConfigParser < SexpProcessor
        
        attr_reader :config_options
    
        def initialize
          super
          self.auto_shift_type = true
          @config_options = {}
        end
        
        def process_attrasgn(exp)
          object = exp.shift
          variable = exp.shift
          value = exp.shift
          
          ap object
          
          variable = variable[0...-1].to_sym
          value = value[1][1]
          @config_options[variable] = value
          exp
        end
        
        def process_op_asgn2(exp)
          ap exp
        end
      end
    end
  end
end