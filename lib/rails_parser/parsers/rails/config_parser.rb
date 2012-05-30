module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Rails #:nodoc:
      
      class ConfigParser < RailsParser::Parsers::BaseParser
        
        attr_reader :configuration
    
        def initialize
          super
          @configuration = {}
        end
        
        def process(exp)
          super
        end
        
        def process_attrasgn(exp)
          parse_config_option(exp[1], exp[2], exp[3])
          exp
        end
        
        def process_op_asgn2(exp)
          parse_config_option(exp[1], exp[2], exp[4], exp[3])
          exp
        end
        
        private
          def parse_config_option(object, method, value, modifer = nil)
          
            # Get the call tree
            call_tree_parser = Ruby::CallTreeParser.parse(object)
            call_tree = call_tree_parser.call_tree
          
            # Strip off the first value, which should be :config
            # If it's not then we don't care about this node at all
            # We only care about config values.
            if :config != call_tree.shift[:name]
              return
            end
          
            # Turn the call tree into nodes on @configuration, retaining the 
            # last segment to set the value on.
            last_segment = call_tree.inject(@configuration) do |h, call|
              h[call[:name]] ||= {}
              h[call[:name]]
            end
          
            # Set the value
            method = method[0..-2].to_sym
            value  = value.to_value
            last_segment[method] = value
          end
      end
    end
  end
end