module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Ruby #:
      class ArgsListParser < RailsParser::Parsers::BaseParser
        
        attr_accessor :arguments
        
        def initialize
          super
          self.auto_shift_type = true
        end
        
        def parse(exp)
          @arguments = []
          super
        end
        
        def process_arglist(exp)
          #ap exp
          while !exp.empty?
            argument = exp.shift
            case argument[0]
            when :lit
              @arguments << {type: :literal, value: argument[1]}
            when :str
              @arguments << {type: :string, value: argument[1]}
            when :call
              name = argument[2]
              sub_args_list_parser = ArgsListParser.parse(argument[3])
              
              @arguments << {type: :method_call, value: Blueprints::Ruby::MethodCallBlueprint.new(name, arguments: sub_args_list_parser.arguments)}
            end
          end
          exp
        end
      end
    end
  end
end
      