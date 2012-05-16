module RailsAuditor #:nodoc:
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
      
      class ApplicationConfigParser < SexpProcessor
        
        attr_reader :application_name
    
        def initialize
          super
          self.auto_shift_type = true
        end
        
        def parse(filepath)
          content = File.read(filepath)
          sexp = RubyParser.new.process(content)
          process(sexp)
        end
        
        def process_module(exp)
          @application_name = exp.shift.to_s
          module_exp = exp.shift
          exp
        end
      end
    end
  end
end