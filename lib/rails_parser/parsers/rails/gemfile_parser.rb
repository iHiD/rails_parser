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
          
          case exp[2]
          when :gem
            parse_gem(exp[3].to_value, exp[4..-1]) 
          when :group
            @current_groups = exp[3..-1].map(&:to_value)
          when :source
            @source = exp[3].to_value
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
          if arguments_exp && arguments_exp.length > 0
            case arguments_exp[0][0]
            when :str
              options.merge!({version: arguments_exp[0].to_value})
            when :hash
              options.merge!(arguments_exp[0].to_hash)
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