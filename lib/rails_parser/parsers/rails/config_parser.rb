module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Rails #:nodoc:
      
      class ConfigParser < SexpProcessor
        
        attr_reader :config_options
    
        def initialize
          super
          self.auto_shift_type = true
          @config_options = []
        end
        
        def process(exp)
          super
        end
        
        def process_attrasgn(exp)
          object = exp.shift
          variable = exp.shift
          value = exp.shift
          
          variable = variable[0...-1].to_sym
          
          # If we have a specified type
          if value[1].length > 1
            value = value[1][1]
          else
            value = value[1][0]
          end
          
          call_tree_parser = Ruby::CallTreeParser.parse(object)
          call_tree = call_tree_parser.call_tree
          call_tree.shift # Remove the :config call
          
          call_tree.push(Blueprints::Ruby::MethodCallBlueprint.new(variable, arguments: [value]))
          config_options << call_tree
          
          exp
        end
      end
    end
  end
end