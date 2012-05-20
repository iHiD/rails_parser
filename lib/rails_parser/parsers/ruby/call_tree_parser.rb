module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Ruby #:
      class CallTreeParser < SexpProcessor
        
        attr_accessor :call_tree
        
        def initialize
          super
          self.auto_shift_type = true
        end
        
        def parse(exp)
          @call_tree = []
          process(exp)
        end 
        
        def process_call(exp)
          parent = exp.shift
          method = exp.shift
          args = exp.shift
          
          argsListParser = ArgsListParser.new
          argsListParser.parse(args)
          
          @call_tree.unshift(Blueprints::Ruby::MethodCallBlueprint.new(method, arguments: argsListParser.arguments))
          process(parent)
          exp
        end
        
        def process_arglist(exp)
        end
        
        def self.parse(exp)
          parser = self.new
          parser.parse(exp)
          parser
        end
      end
    end
  end
end
      