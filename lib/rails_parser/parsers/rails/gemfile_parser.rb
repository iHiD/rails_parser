module RailsParser #:nodoc:
  module Parsers #:nodoc:
    module Rails #:nodoc:
      # = Gemfile Parser
      #
      # The class inspects a gemfile and extracts the source and the gems
      #
      # It works like this:
      # parser = GemfileParser.new 
      # parser.parse("/path/to/Gemfile")
      # parser.gems = {rails: {blueprint: <Blueprints::GemBlueprint>, groups: [:test, :development]}}
      class GemfileParser < RailsParser::Parsers::BaseParser
      
        attr_reader :gems
        attr_reader :source
    
        def initialize
          super
          @gems = {}
          @current_groups = []
        end
      
        def process_call(exp)
          
          arguments_exp = exp[3]
          
          case exp[2]
          when :gem
            parse_gem(arguments_exp[1].to_value, arguments_exp[2]) 
          when :group
            @current_groups = arguments_exp.to_a
          when :source
            @source = arguments_exp[1].to_value
          end
          exp
        end
      
        def process_iter(exp)
          exp[1..-1].each {|node| process(node) }
          @current_groups = []
          exp
        end
      
        def parse_gem(name, arguments_exp)
          
          options = {name: name, groups:[]}
          if arguments_exp
            case arguments_exp[0]
            when :str
              options.merge!({version: arguments_exp.to_value})
            when :hash
              options.merge!(arguments_exp.to_hash)
            else 
              raise ArgumentError, "Unknown Gem Pattern"
            end
          end
          options[:groups] = [options.delete(:group)].compact
        
          @gems[name.to_sym] ||= {}
          @gems[name.to_sym].merge!(options)
          @gems[name.to_sym][:groups] += @current_groups
        end
      end
    end
  end
end